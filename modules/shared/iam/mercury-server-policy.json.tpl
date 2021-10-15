{
    "Version": "2012-10-17",
    "Statement": [{
        "Sid": "VisualEditor1",
        "Effect": "Allow",
        "Action": [
            "s3:ListBucket",
            "s3:DeleteObject",
            "s3:GetObject",
            "s3:GetObjectAcl",
            "s3:PutObject",
            "s3:PutObjectAcl"
        ],
        "Resource": [
            "${resource}",
            "${resource}/*"
        ]
    }]
}