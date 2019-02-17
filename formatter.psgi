#!/usr/bin/env perl

use 5.28.0;
use utf8;
use strict;
use warnings;

use Plack::Request;
use Plack::Response;
use XML::Atom::Client;
use XML::Atom::Feed;
use XML::Atom::Content;

my $api = XML::Atom::Client->new;
my $app = sub {
    my $env = shift;
    my $req = Plack::Request->new($env);
    my $url = $req->request_uri;
    $url = "/$url" if $url !~ m(\A/);
    return [404, ["Content-Type" => "text/plain"], "not found"] if $url !~ /\.atom/
    my $feed = $api->getFeed('https://github.com' . $url) or die $api->errstr;
    my $newfeed = XML::Atom::Feed->new;
    $newfeed->id($feed->id);
    $newfeed->title($feed->title);
    my @entries = $feed->entries;
    for my $entry(@entries) {
        $entry->content(XML::Atom::Content->new(Body => '', Version => $entry->version));
        $newfeed->add_entry($entry);
    }

    my $res = Plack::Response->new(200);
    $res->content_type('application/atom+xml; charset=utf-8');
    $res->body($newfeed->as_xml);
    return $res->finalize;
};
