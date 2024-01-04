#!/bin/bash

cat > index.html <<EOF
<h1>Hello, World</h1>
<p>End of line</p>
EOF

nohup busybox httpd -f -p 8080 &