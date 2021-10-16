{
    "Version": "2012-10-17",
    "Statement": [{
        "Sid": "VisualEditor1",
        "Effect": "Allow",
        "Action": [
            "s3:DeleteObject",
            "s3:GetObject",
            "s3:GetBucketLocation",
            "s3:ListAllMyBuckets",
        ],
        "Resource": [
            "${resource}",
            "${resource}/*"
        ]
    }]
}