# Домашнее задание к занятию "13.1 контейнеры, поды, deployment, statefulset, services, endpoints"

1. Stage контур
   
    ```yaml
    apiVersion: v1
    kind: Namespace
    metadata:
      name: stage
    ```

    ```yaml
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      labels:
        app: main-app
      name: main-app
      namespace: stage
    spec:
      replicas: 1
      selector:
        matchLabels:
          app: main-app
      template:
        metadata:
          labels:
            app: main-app
          namespace: stage
        spec:
          containers:
            - image: develtime/example-backend:latest
              imagePullPolicy: IfNotPresent
              name: example-backend
            - image: develtime/example-frontend:latest
              imagePullPolicy: IfNotPresent
              name: example-frontend
          terminationGracePeriodSeconds: 30
    ```

    ```yaml
    apiVersion: v1
    kind: Service
    metadata:
      name: db
      labels:
        app: db
      namespace: stage
    spec:
      ports:
      - port: 5432
        name: tcp-postgresql
        protocol: TCP
      clusterIP: None
      selector:
        app: postgres
    ```

    ```yaml
    apiVersion: v1
    kind: PersistentVolumeClaim
    metadata:
      name: local-path-postgresql
      namespace: stage
    spec:
      accessModes:
        - ReadWriteOnce
      storageClassName: local-path
      resources:
        requests:
          storage: 128Mi
    ```

    ```yaml
    apiVersion: apps/v1
    kind: StatefulSet
    metadata:
      name: postgres
      namespace: stage
      labels:
        app: postgres
    spec:
      serviceName: db
      selector:
        matchLabels:
          app: postgres
      replicas: 1
      template:
        metadata:
          name: postgres
          labels:
            app: postgres
        spec:
          containers:
          - name: postgresql
            image: docker.io/bitnami/postgresql:11.7.0-debian-10-r9
            ports:
            - containerPort: 5432
              name: tcp-postgresql
              protocol: TCP
            env:
              - name: POSTGRESQL_USERNAME
                value: postgres
              - name: POSTGRESQL_PASSWORD
                value: postgres
              - name: POSTGRESQL_DATABASE
                value: news
            volumeMounts:
            - name: postgres-persistent-storage
              mountPath: /bitnami/postgresql
          volumes:
          - name: postgres-persistent-storage
            persistentVolumeClaim:
              claimName: local-path-postgresql
          restartPolicy: Always
    ```

    p.s. Для упрощения работы с `PersistentVolume` в рамках ДЗ использовался данный [репозиторий](https://github.com/rancher/local-path-provisioner).

2. Production контур

    Postgresql такой-же как и в namespace `stage` отличается только пространством имен

    ```yaml
    apiVersion: v1
    kind: Namespace
    metadata:
      name: production
    ```

    ```yaml
    ---
    apiVersion: v1
    kind: Service
    metadata:
      name: main-backend-service
      labels:
        app: main-backend-service
      namespace: production
    spec:
      ports:
      - port: 9000
        name: tcp-main-app
        protocol: TCP
      clusterIP: None
      selector:
        app: main-app-backend
    ---
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      labels:
        app: main-app-backend
      name: main-app-backend
      namespace: production
    spec:
      replicas: 1
      selector:
        matchLabels:
          app: main-app-backend
      template:
        metadata:
          labels:
            app: main-app-backend
          namespace: production
        spec:
          containers:
            - image: develtime/example-backend:latest
              imagePullPolicy: IfNotPresent
              name: prod-backend
              ports:
              - containerPort: 9000
                name: tcp-main-app
                protocol: TCP
              env:
                - name: DATABASE_URL
                  value: postgres://postgres:postgres@db:5432/news
          terminationGracePeriodSeconds: 30
    ```

    ```yaml
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      labels:
        app: main-frontend-app
      name: main-frontend-app
      namespace: production
    spec:
      replicas: 1
      selector:
        matchLabels:
          app: main-frontend-app
      template:
        metadata:
          labels:
            app: main-frontend-app
          namespace: production
        spec:
          containers:
            - image: develtime/example-frontend:latest
              imagePullPolicy: IfNotPresent
              name: production-frontend
              env:
                - name: BASE_URL
                  value: "http://main-backend-service:9000"
          terminationGracePeriodSeconds: 30
    ```