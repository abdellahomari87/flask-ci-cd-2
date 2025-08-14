data "aws_caller_identity" "current" {}

# ---- Trust policies (root du compte + condition sur aws:PrincipalArn) ----
data "aws_iam_policy_document" "trust_admin" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    # on fait confiance au root du compte (toujours valide)
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }

    # on restreint aux ARNs autorisés (user IAM, rôle IAM, rôle SSO)
    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalArn"
      values   = var.allowed_admin_principals
    }
  }
}

data "aws_iam_policy_document" "trust_dev" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalArn"
      values   = var.allowed_dev_principals
    }
  }
}

# ---- Roles ----
resource "aws_iam_role" "eks_admin" {
  name               = "eks-admin"
  assume_role_policy = data.aws_iam_policy_document.trust_admin.json
}

resource "aws_iam_role" "eks_devs" {
  name               = "eks-devs"
  assume_role_policy = data.aws_iam_policy_document.trust_dev.json
}

# ---- Politique minimale EKS pour update-kubeconfig ----
data "aws_iam_policy_document" "eks_readonly" {
  statement {
    effect    = "Allow"
    actions   = ["eks:DescribeCluster", "eks:ListClusters"]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "eks_admin_readonly" {
  name   = "eks-readonly"
  role   = aws_iam_role.eks_admin.id
  policy = data.aws_iam_policy_document.eks_readonly.json
}

resource "aws_iam_role_policy" "eks_devs_readonly" {
  name   = "eks-readonly"
  role   = aws_iam_role.eks_devs.id
  policy = data.aws_iam_policy_document.eks_readonly.json
}