{
    "Version": "2012-10-17",
    "Statement": [{
        "Sid": "VisualEditor1",
        "Effect": "Allow",
        "Action": [
            "s3:ListBucket",
            "s3:PutObject"
        ],
        "Resource": [
            "${resource}",
            "${resource}/*"
        ]
    }]
}