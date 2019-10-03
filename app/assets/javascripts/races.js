window.addEventListener('message', handleMessage, false);

$(document).on('change', '.btn-file input', function () {
  $(event.target).closest('form').submit();
})

function handleMessage(event) {
  if (event.origin === window.allowedOrigin) {
    var data = JSON.parse(event.data);

    if (data.deviceId) {
      $.get(window.location.href + '/' + data.deviceId + '.js');
    } else {
      $('.device-actions').addClass('hidden');
    }
  }
}

function initializeMap() {
  var $map = $('#map');

  if ($map.length) {
    var map = L.map($map.attr('id'), defaultMapOptions());

    addTracksToMap($map.data('tracks'), map)
  }
}

function initializeRouteMaps() {
  var $maps = $('.route-map');

  $maps.each(function(i, element) {
    var map = L.map(element.id, defaultMapOptions());

    var $routeInput = $(element).closest('.form-group').find('.track-route');
    var route = JSON.parse($routeInput.val());

    var polyline = L.polyline(route, {
      color: getTrackColor('speed')
    });

    fitPolyline();

    $routeInput.on('change', function() {
      map.removeLayer(polyline);

      polyline = L.polyline(JSON.parse($routeInput.val()), {
        color: getTrackColor('speed')
      });

      fitPolyline();
    });

    map.on('click', function(event) {
      var latlng = event.latlng;

      navigator.clipboard.writeText(latlng.lat + ',' + latlng.lng);
    });

    function fitPolyline() {
      polyline.addTo(map);

      map.fitBounds(polyline.getBounds());
    }
  });
}

function defaultMapOptions() {
  return {
    layers: L.tileLayer('https://{s}.tile.openstreetmap.fr/osmfr/{z}/{x}/{y}.png', {
      attribution: '&copy; Openstreetmap France | &copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>',
      maxZoom: 20,
    }),
    maxBounds: [
      [56.979041, 19.577637],
      [52.933327, 28.586426]
    ],
    zoomSnap: 0.5,
  };
}

function getTrackColor(kind) {
  switch (kind) {
    case 'speed':
      return 'red';
    case 'passage':
      return 'blue';
    case 'limited':
      return 'black';
  }
}

function addTracksToMap(tracks, map) {
  tracks.forEach(function (track) {
    var route = track.route;
    var nonOpaque = track.kind === 'speed' || track.kind === 'limited';

    var polyline = L.polyline(route, {
      color: getTrackColor(track.kind),
      opacity: nonOpaque ? 1 : 0.3,
    });

    var $tooltip = $('.absolute-tooltip[data-id=' + track.id + ']');

    var startPosition = route[0];
    var endPosition = route[route.length - 1];

    if (track.kind === 'speed') {
      L.marker(startPosition).bindPopup(popupText('start', startPosition)).addTo(map);
      L.marker(endPosition).bindPopup(popupText('end', endPosition)).addTo(map);
    }

    polyline.on('mouseover', function (event) {
      $tooltip.css({ top: event.containerPoint.y, left: event.containerPoint.x + 25 }).tooltip('show');

      event.target.setStyle({ weight: 10 });
    });

    polyline.on('mouseout', function (event) {
      $tooltip.tooltip('hide');

      event.target.setStyle({ weight: 5 });
    });

    if (true) {
      polyline.addTo(map);
    } else {
      // Draw track as points
      route.forEach(function (point) { L.marker(point).addTo(map) });
    }

    function popupText(name, position) {
      var speedLimit = track.kind === 'limited' ? '<br>Speed limit: ' + track.speed_limit : '';

      return track.name + ' ' + track.kind + ' ' + name + '<br>Position: ' + position.join(',') + '<br>Track length: ' + track.length_in_km + speedLimit;
    }
  });

  map.fitBounds(L.polyline(_.flatten(tracks.map(function (track) { return track.route }))).getBounds());
}
