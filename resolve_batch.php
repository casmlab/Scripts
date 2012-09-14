<?php require_once('URLResolver.php');
$resolver = new URLResolver();

# Identify your crawler (otherwise the default will be used)
$resolver->setUserAgent('Mozilla/5.0 (compatible; CaSM/1.0; +http://www.casmlab.org)');

# Designate a temporary file that will store cookies during the session.
# Some web sites test the browser for cookie support, so this enhances results.
$resolver->setCookieJar('/tmp/url_resolver.cookies');

# resolveURL() returns an object that allows for additional information.
$urls = array("http://tinyurl.com/bpgsndk","http://bit.ly/yVZNSf");
$myFile = "longUrls.txt";
$fh = fopen($myFile, 'w') or die("can't open file");

foreach ($urls as $url){
	$url_result = $resolver->resolveURL($url);

	# Test to see if any error occurred while resolving the URL:
	if ($url_result->didErrorOccur()) {
		print "there was an error resolving $url:\n  ";
		print $url_result->getErrorMessageString();
	}

	# Otherwise, print out the resolved URL.  The [HTTP status code] will tell you
	# additional information about the success/failure. For instance, if the
	# link resulted in a 404 Not Found error, it would print '404: http://...'
	# The successful status code is 200.
	else {
		$stringData = $url_result->getHTTPStatusCode() . ": " . $url_result->getURL() . " " . $url . "\n";
		fwrite($fh, $stringData);
		
	}

}
fclose($fh);