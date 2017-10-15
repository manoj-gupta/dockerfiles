docker run --name some-blog -d -p 80:2368 -e VIRTUAL_HOST=domain.com -v /home/ghost/blogfiles/:/var/lib/ghost --restart unless-stopped ghost
