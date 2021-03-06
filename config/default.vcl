vcl 4.0;

import directors;

backend nginx {
    .host = "127.0.0.1";
    .port = "81";
    .probe = {
	.url = "/";
        .timeout = 1s;
        .interval = 5s;
        .window = 5;
        .threshold = 3;
    }
}

backend apache {
    .host = "127.0.0.1";
    .port = "82";
    .probe = {
	.url = "/";
        .timeout = 1s;
        .interval = 5s;
        .window = 5;
        .threshold = 3;
    }
}

sub vcl_init {
    new lb = directors.round_robin(); # Creating a Load Balancer
    lb.add_backend(nginx); # Add Virtual Host 1
    lb.add_backend(apache); # Add Virtual Host 2
}

sub vcl_recv {
    set req.backend_hint = lb.backend();
}
