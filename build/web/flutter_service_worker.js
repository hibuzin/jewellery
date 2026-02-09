'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "921ef25a7f168b03f2773ca10e0bd46c",
"assets/AssetManifest.bin.json": "50401af7dc4a3b05b82e17bb1525f403",
"assets/assets/advertisement/13178da4": "828c4a20d87b97c8bf2c5adc4380cf20",
"assets/assets/advertisement/1d7e9757": "828c4a20d87b97c8bf2c5adc4380cf20",
"assets/assets/advertisement/3a86c926": "636165a3ac727495b0e062af10fff0e0",
"assets/assets/advertisement/42c0a6a": "0b606843acad1d95554d491f0e0fd0b9",
"assets/assets/advertisement/54921a7a": "636165a3ac727495b0e062af10fff0e0",
"assets/assets/advertisement/68efbf1": "0b606843acad1d95554d491f0e0fd0b9",
"assets/assets/advertisement/72653349": "636165a3ac727495b0e062af10fff0e0",
"assets/assets/advertisement/72a13656": "0b606843acad1d95554d491f0e0fd0b9",
"assets/assets/advertisement/7c79f1a5": "4bfe9dedc2492a213951fba2180b6fcd",
"assets/assets/advertisement/7c8a00f6": "4bfe9dedc2492a213951fba2180b6fcd",
"assets/assets/advertisement/873dd01": "4bfe9dedc2492a213951fba2180b6fcd",
"assets/assets/advertisement/8798787a": "636165a3ac727495b0e062af10fff0e0",
"assets/assets/advertisement/904f0b1a": "0b606843acad1d95554d491f0e0fd0b9",
"assets/assets/advertisement/91d075f2": "0b606843acad1d95554d491f0e0fd0b9",
"assets/assets/advertisement/a2438789": "828c4a20d87b97c8bf2c5adc4380cf20",
"assets/assets/advertisement/Banner2.png": "4bfe9dedc2492a213951fba2180b6fcd",
"assets/assets/advertisement/Banner3.png": "0b606843acad1d95554d491f0e0fd0b9",
"assets/assets/advertisement/Banner4.png": "828c4a20d87b97c8bf2c5adc4380cf20",
"assets/assets/advertisement/Banner5.png": "636165a3ac727495b0e062af10fff0e0",
"assets/assets/advertisement/d76b159d": "828c4a20d87b97c8bf2c5adc4380cf20",
"assets/assets/advertisement/d807ae57": "828c4a20d87b97c8bf2c5adc4380cf20",
"assets/assets/advertisement/f3817ef": "636165a3ac727495b0e062af10fff0e0",
"assets/assets/advertisement/img.png": "b9b56732a96a85332f2c7acd0542763e",
"assets/assets/advertisement/img_1.png": "d4aee9aa00a9fd82bd26395fe5a2aaf3",
"assets/assets/advertisement/img_10.png": "ef01052761c65a4936855915c75f2f26",
"assets/assets/advertisement/img_2.png": "eb133546142b38c40de6d2e031454a7c",
"assets/assets/advertisement/img_3.png": "cb1554270367cef008769346ddeca158",
"assets/assets/advertisement/img_4.png": "b92f89421cdada464c4cdc67081bbae7",
"assets/assets/advertisement/img_5.png": "a79baf6a745471d7a39900576367daaf",
"assets/assets/advertisement/img_6.png": "269a2823869ad745fc76ebdf3b89cb0e",
"assets/assets/advertisement/img_7.png": "60c7be9a3638f047a1290ec977ff1263",
"assets/assets/advertisement/img_8.png": "7042bf3562dbfeb67033fb99b4f2fa56",
"assets/assets/advertisement/img_9.png": "050b2a666628a67e5e0684fe1a7e3e64",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "a972f647b256fde8db5f9dad0de1f6ea",
"assets/NOTICES": "b04be3ce2378228ffc9ef2dfea914c1e",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "25cbc51c797ba7d93671c48a4179cba7",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"canvaskit/canvaskit.js": "8331fe38e66b3a898c4f37648aaf7ee2",
"canvaskit/canvaskit.js.symbols": "a3c9f77715b642d0437d9c275caba91e",
"canvaskit/canvaskit.wasm": "9b6a7830bf26959b200594729d73538e",
"canvaskit/chromium/canvaskit.js": "a80c765aaa8af8645c9fb1aae53f9abf",
"canvaskit/chromium/canvaskit.js.symbols": "e2d09f0e434bc118bf67dae526737d07",
"canvaskit/chromium/canvaskit.wasm": "a726e3f75a84fcdf495a15817c63a35d",
"canvaskit/skwasm.js": "8060d46e9a4901ca9991edd3a26be4f0",
"canvaskit/skwasm.js.symbols": "3a4aadf4e8141f284bd524976b1d6bdc",
"canvaskit/skwasm.wasm": "7e5f3afdd3b0747a1fd4517cea239898",
"canvaskit/skwasm_heavy.js": "740d43a6b8240ef9e23eed8c48840da4",
"canvaskit/skwasm_heavy.js.symbols": "0755b4fb399918388d71b59ad390b055",
"canvaskit/skwasm_heavy.wasm": "b0be7910760d205ea4e011458df6ee01",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"flutter_bootstrap.js": "0c169bbc548ac966c0aab67dfeaad517",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "c383f464bd9a424122c85e5b13c4ec41",
"/": "c383f464bd9a424122c85e5b13c4ec41",
"main.dart.js": "4ab2d05617b86d7c17ff2dd63cb03902",
"manifest.json": "52be576dd17dcd1f192acb67f94c5ce7",
"version.json": "48c560d43270750dc6aa488c2d572e24"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
