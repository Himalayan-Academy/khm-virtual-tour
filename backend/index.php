<?php
/**
 * This is the Virtual Tour API server
 * 
 * Author: Andre Alves Garzia <andre@andregarzia.com>
 * Date: 2018-09-24
 * 
 * It is a minimal server, only the features needed to make the Virtual Tour work.
 * All data is based on files on disk and caching of processed results.
 * 
 * URLS:
 * 
 * /locations -> map plottable points of interest
 * 
 * /location/<name> -> data about given point
 * 
 * /refesh-cache -> rebuilds cache.
 */

use \Psr\Http\Message\ServerRequestInterface as Request;
use \Psr\Http\Message\ResponseInterface as Response;
use \Gumlet\ImageResize;

require 'vendor/autoload.php';

global $cacheEnabled;
$cacheEnabled = false;

/**
 * AUXILIARY ROUTINES
 */

function isSafeLocationIdentifier($location) {
    if (preg_match("/^[A-Za-z0-9-]+$/", $location)) {
        // location identifiers contains only letters, numbers and hyphens
        return true;
    } else {
        // does not contain only letters, numbers, and hyphens
        // potential attack.
        return false;
    }
}

 function locationStatus($location) {
     global $cacheEnabled;
    
    if (!isSafeLocationIdentifier($location)) {
        return false;
    }

    if (!file_exists("./points-of-interest/$location/item.json")) {
        return false;
    }

    if (file_exists("./points-of-interest/$location/cached.json") && $cacheEnabled) {
        return "cached";
    } else {
        return "not-cached";
    }

    return false;
 }

 function locationFromDisk($location) {
    $data = array(
        'metadata' => metadataFromLocation($location),
        'panoramas' => panoramasFromLocation($location), 
        'videos' => videosFromLocation($location), 
        'quad-videos' => quadVideosFromLocation($location), 
        'slideshows' => slideshowsFromLocation($location), 
    );

    file_put_contents(
        "./points-of-interest/$location/cached.json", 
        json_encode($data, JSON_PRETTY_PRINT)
    );

    $data["cached"] = false;

    return $data;
 }

 function locationFromCache($location) {
    $json = file_get_contents("./points-of-interest/$location/cached.json");
    $location_data = json_decode($json,true);
    $location_data["cached"] = true;

    return $location_data;
 }

 function refreshCache() {

 }

 function locationsFromCache() {

 }

 function metadataFromLocation($location) {
    $json = file_get_contents("./points-of-interest/$location/item.json");
    $location_metadata = json_decode($json,true);
    $location_metadata['hero_image'] = "points-of-interest/$location/${location_metadata['hero_image']}";
    return $location_metadata;
 }

 function updateLocation($location, $x, $y) {
    $json = file_get_contents("./points-of-interest/$location/item.json");
    if ($json !== false) {
        $location_data = json_decode($json,true);
        if (json_last_error() === JSON_ERROR_NONE) { 
            $location_data["x"] = $x;
            $location_data["y"] = $y;
            file_put_contents("./points-of-interest/$location/item.json", json_encode($location_data, true));
            return "ok. location saved.";
        } else {
            $error = json_las_error();
            return "error. json error: $error";
        }
    } else {
        return "error. file reading error";
    }
}

 function panoramasFromLocation($location) {
    $helper = function($image) {
        $captionFile = str_replace(".jpg",".txt",$image);
        if (file_exists($captionFile)) {
            return Array(
                "image" => $image,
                "caption" => file_get_contents($captionFile)
            );
        } else {
            return Array(
                "image" => $image,
                "caption" => ""
            );
        }
    };

    $folder = "points-of-interest/$location/panoramas/*.jpg";
    $images = glob($folder);
    $response = array_map($helper, $images);

    return $response;
 }

function videosFromLocation($location) {
    $helper = function($video) {
        $ext = pathinfo($video, PATHINFO_EXTENSION);
        $captionFile = str_replace($ext,"txt",$video);
        $poster = str_replace($ext,"jpg",$video);
        if (file_exists($captionFile)) {
            $caption = file_get_contents($captionFile);
        } else {
            $caption = "";
        }

        if ($ext == "url") {
            $kind = "youtube";
            $value = file_get_contents($video);
        } else {
            $kind = "video";
            $value = $video;
        }

        return array(
            'kind' => $kind, 
            'poster' => $poster,
            'caption' => trim($caption), 
            'video' => trim($value)  
        );
    };

    $folder = "points-of-interest/$location/video/*.{mp4,url}";
    $videos = glob($folder, GLOB_BRACE);
    $response = array_map($helper, $videos);

    return $response;
}

function quadVideosFromLocation($location) {
    $helper = function($video) {
        $ext = pathinfo($video, PATHINFO_EXTENSION);
        $captionFile = str_replace($ext,"txt",$video);
        $poster = str_replace($ext,"jpg",$video);
        if (file_exists($captionFile)) {
            $caption = file_get_contents($captionFile);
        } else {
            $caption = "";
        }

        if ($ext == "url") {
            $kind = "youtube";
            $value = file_get_contents($video);
        } else {
            $kind = "video";
            $value = $video;
        }

        return array(
            'kind' => $kind, 
            'poster' => $poster,
            'caption' => trim($caption), 
            'video' => trim($value)  
        );
    };

    $folder = "points-of-interest/$location/quad-video/*.{mp4,url}";
    $videos = glob($folder, GLOB_BRACE);
    $response = array_map($helper, $videos);

    return $response;
}

function slideshowsFromLocation($location) {
    $helper = function($image) {
        $captionFile = str_replace(".jpg",".txt",$image);
        if (file_exists($captionFile)) {
            return Array(
                "image" => $image,
                "caption" => file_get_contents($captionFile)
            );
        } else {
            return Array(
                "image" => $image,
                "caption" => ""
            );
        }
    };

    $folder = "points-of-interest/$location/slideshow/*.jpg";
    $images = glob($folder);
    $response = array_map($helper, $images);

    return $response;
}


function allLocations() {
    $helper = function($locationJsonPath) {
        // error_log("loc: ${locationJsonPath}");
        $locationJson = file_get_contents($locationJsonPath);
        $location_data = json_decode($locationJson,true);
        if (json_last_error() == JSON_ERROR_NONE) {
            return $location_data;
        } else {
            $jerr = json_last_error_msg();
            error_log("error decoding $locationJsonPath: $jerr");
            return false;
        }
    };

    $filter = function($location) {
        try {
            $keys = Array(
                "hero_image", 
                "about", 
                "x", 
                "y",
                "description",
                "title",
                "id");
            foreach($keys as $k) {
                if (!isset($location[$k])) {
                    return false;
                }
            }
            return true;
        } catch(Exception $e) {
            return false;
        }
    };

    $folders = "points-of-interest/**/item.json";
    $locations = glob($folders);
    $response = array_map($helper, $locations);
    $response = array_filter($response, $filter);

    return $response;
}

/**
 * ROUTES HANDLING
 */

$app = new \Slim\App;

$app->options('/{routes:.+}', function ($request, $response, $args) {
    return $response;
});

$app->add(function ($req, $res, $next) {
    $response = $next($req, $res);
    return $response
            ->withHeader('Access-Control-Allow-Origin', '*')
            ->withHeader('Access-Control-Allow-Headers', 'X-Requested-With, Content-Type, Accept, Origin, Authorization')
            ->withHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, PATCH, OPTIONS');
});

$app->get('/setposition/{location}/{x}/{y}', function (Request $request, Response $response, array $args) {
    $location = $args['location'];
    $x = floatval($args['x']);
    $y = floatval($args['y']);

    $result = updateLocation($location, $x, $y);


    $response->getBody()->write("saving $location $x $y: $result");

    return $response;
});

$app->get('/thumb/{maxWidth}/{location}/{type}/{file}', function (Request $request, Response $response, array $args) {
    $location = $args['location'];
    $type = $args['type'];
    $file = $args['file'];
    $maxWidth = $args['maxWidth'];
    $path = "./points-of-interest/${location}/${type}/{$file}";
    $cachePath = "points-of-interest/${location}/_cache/${location}-${maxWidth}-{$file}";

    if (!file_exists($cachePath)) {
        if (!is_dir("points-of-interest/${location}/_cache")) {
            mkdir("points-of-interest/${location}/_cache");
        }
        error_log("file: ${path}");
        $image = new ImageResize($path);
        $image->resizeToWidth($maxWidth);
        $image->save($cachePath);
    }
    return $response->withRedirect("/virtualtour/${cachePath}",301);
});

$app->get('/location/{location}', function (Request $request, Response $response, array $args) {
    $location = $args['location'];

    switch (locationStatus($location)) {
        case 'cached':
            $success = array(
                'status' => 'success', 
                'location'=> locationFromCache($location) 
            );

            $newResponse = $response->withJson($success);
            break;

        case 'not-cached':
            $success = array(
                'status' => 'success', 
                'location'=> locationFromDisk($location) 
            );

            $newResponse = $response->withJson($success);
            break;
        
        default:
            $error = array(
                'status' => 'error', 
                'message'=> "${location} not found" 
            );

            $newResponse = $response->withJson($error);
            break;
    }

    return $newResponse;
});

$app->get('/locations', function (Request $request, Response $response, array $args) {
    $data = array("locations" => allLocations());
    $newResponse = $response->withJson($data);
    return $newResponse;
});

$app->get('/refresh-cache', function (Request $request, Response $response, array $args) {
    $location = $args['location'];
    $response->getBody()->write("Hello, $location");

    return $response;
});

// Catch-all route to serve a 404 Not Found page if none of the routes match
// NOTE: make sure this route is defined last
$app->map(['GET', 'POST', 'PUT', 'DELETE', 'PATCH'], '/{routes:.+}', function($req, $res) {
    $handler = $this->notFoundHandler; // handle using the default Slim page not found handler
    return $handler($req, $res);
});


$app->run();