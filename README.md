# Apache2 Reverse Proxy Configuration

## Services

### proxy

The Apache2 service responsible for handling all proxy requests.

## Adding Services to Be Reverse Proxied

Services that require reverse proxying must join the Docker network named "proxy". Once the service is part of this network, you can add site proxy information in the "sites" directory.

### Example Site Configuration

Here's an example of a VirtualHost configuration for a site that's reverse proxied:

```apache
<VirtualHost *:443>
    ServerName  influx.eqe-lab.com
    SSLEngine on
    SSLProxyEngine On
    SSLProxyVerify none
    RewriteEngine On
    RewriteCond %{HTTP:Connection} Upgrade [NC]
    RewriteCond %{HTTP:Upgrade} websocket [NC]
    RewriteRule ^/(.*) ws://influxdb:8086/$1  [P,L]
    <Location />
        # only allow access from the local network
        Require ip 10.0.0.0/8
        Require ip 192.168.0.0/16
        RequestHeader set X-Forwarded-Proto "https"
        RequestHeader set "X-Forwarded-SSL" expr=%{HTTPS}
        RequestHeader set Host %{HTTP_HOST}e
        ProxyPass http://influxdb:8086/
        ProxyPassReverse http://influxdb:8086/
    </Location>   
    ErrorLog ${APACHE_LOG_DIR}/influx_error.log
    CustomLog ${APACHE_LOG_DIR}/influx_access.log combined 
</VirtualHost>
```

This configuration reverse proxies traffic to the InfluxDB service running within the Docker network.

## Running

To start this setup, ensure that you have properly set up the environment variables and relevant certificate/secret files. Then run the following command from the project's root directory:

```bash
docker-compose up -d
```

or

```bash
./restart.sh
```

## License and Contact

The license for this project should be described in the LICENSE file in the root directory. For more information or support, you can contact via email at tachen@phys.ethz.ch.
