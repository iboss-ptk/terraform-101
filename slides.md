---
title: Terraform 101
author: Supanat Potiwarakorn
patat:
  incrementalLists: true
  slideLevel: 2
  wrap: true
  margins:
    left: 60
    right: 60
  pandocExtensions:
    - patat_extensions
    - autolink_bare_uris
    - emoji
...

# Terraform 101
## Code Example

creating an ec2 instance
```json
resource "aws_instance" "web" {
  ami = "ami-408c7f28"
}
```

