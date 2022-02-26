# wordzoo-web-apex-wrapper

Repository URL: https://github.com/jaredrhine/wordzoo-web-apex-wrapper

Author: Jared Rhine <<jared@wordzoo.com>>

Keywords: fly.io, Caddy, Docker, HTTP proxy, apex domain, wordzoo.com

## Purpose

The code in this repository solves a particular web hosting
configuration challenge, using a combination of fly.io Docker
container hosting and a CDN.

The desired configuration includes:

- Static site pattern. The application is a small vue.js static build, compiled down to a single index.html file plus supporting CSS/JS/img assets.
- A choice of 3rd party CDNs. It should be possible to switch various providers (I've used all of Cloudfront, bunny.net, KeyCDN).
- Full regular slash-separated path URLs, not URLs with fragments using a hash (#) separator.
- All URLs should work and return HTTP 200 not 404s.
- Supports multiple domains jared.wordzoo.com and apex domain wordzoo.com for HTTP, www.wordzoo.com redirects too.
- Configurable behavior, including redirection, http-to-https, and generalized proxying.
- SSL certificates for free and with no maintenance

## Problems with other solutions

With other solutions (involving AWS S3, Backblaze B2, KeyCDN, bunny.net), some problems arise:

- You need more that "static site hosting"; you need richer HTTP rules for mapping a URL like "/projects" to also serve the main built JS app at "index.html". Standard static site hosting can provide "/" actually serving "index.html", but since there's no actual "projects.html" file, trying to fetch such a URL results in a 404.
- S3 can serve the index.html as the "error response" and it sort of works but the HTTP response code is a 404, not a 200. So that S3 response can't be wrapped by a CDN (which will pay attention to the actual 404 code).
- Multiple providers of HTTP-serving stacks will run Let's Encrypt to provide SSL certificates, but will not work for an apex domain (bare wordzoo.com).
- Cloudfront and others can serve your own certificate on apex domains, but then you have to buy your own SSL cert for multi-year certs (or upload Let's Encrypt yourself every few months).

## Architecture of this solution

The resulting architecture to serve HTTP the way I want for wordzoo.com involves these components:

- Accepts that we need the capabilities of a "real" web server to ultimately serve at least some paths.
  - We use the Caddy HTTP server here.
- Uses a docker container.
  - Caddy package
  - Caddy custom configuration file
  - Site directory tree. I already had a system to build my web site and was pushing it to S3. Instead, I now just copy the "dist" directory from that problem into the docker image.
- Host on fly.io
  - fly.io provides both a way to serve an arbitrarily built docker container and Let's Encrypt certificates
- Use a 3rd party CDN to manage anycast distribution instead of fly.io
  - But that's not part of this solution. This solution here serves as the origin URL for a separate CDN configuration.
