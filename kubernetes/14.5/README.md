# Домашнее задание к занятию "14.5 SecurityContext, NetworkPolicies"

1. Security context

    - [Manifest](manifests/01-security-context.yml)

    ![id](img/id.png)

2. Пример с Network policy

    - [Namespace](manifests/00-namespace.yml)
    - [Pods](manifests/02-pods.yml)
    - [Default policy](manifests/03-default-policy.yml)

    ![deny-back-to-front](img/deny-back-to-front.png)

    ![deny-front-to-back](img/deny-front-to-back.png)

    - [Frontend policy](manifests/04-frontend-policy.yml)
    - [Backend policy](manifests/05-backend-policy.yml)

    ![allow-back-to-front](img/allow-back-to-front.png)

    ![allow-front-to-back](img/allow-front-to-back.png)

    ![allow-back-to-www](img/allow-back-to-www.png)

    ![deny-front-to-www](img/deny-front-to-www.png)

    
