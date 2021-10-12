# Домашнее задание к занятию "7.6. Написание собственных провайдеров для Terraform."

1. AWS Provider
   - [DataSources](https://github.com/hashicorp/terraform-provider-aws/blob/main/aws/provider.go#L192)
   - [Resources](https://github.com/hashicorp/terraform-provider-aws/blob/main/aws/provider.go#L480)
   - Параметр [name](https://github.com/hashicorp/terraform-provider-aws/blob/main/aws/resource_aws_sqs_queue.go#L99) конфликтует с параметром [name_prefix](https://github.com/hashicorp/terraform-provider-aws/blob/main/aws/resource_aws_sqs_queue.go#L102)
   - Максимальная длина имени `80` символов
   - [Регулярное выражение](https://github.com/hashicorp/terraform-provider-aws/blob/main/aws/resource_aws_sqs_queue.go#L415)
  