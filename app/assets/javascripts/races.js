window.addEventListener('message', handleMessage, false);

$(document).on('change', '.btn-file input', function () {
  $(event.target).closest('form').submit();
})

function handleMessage (event) {
  if (event.origin === window.allowedOrigin) {
    var data = JSON.parse(event.data);

    if (data.deviceId) {
      $.get(window.location.href + '/' + data.deviceId + '.js');
    } else {
      $('.device-actions').addClass('hidden');
    }
  }
}

function initializeMap () {
  var $map = $('#map');

  if ($map.length) {
    var map = L.map($map.attr('id'), {
      layers: L.tileLayer('https://{s}.tile.openstreetmap.fr/osmfr/{z}/{x}/{y}.png', {
        attribution: '&copy; Openstreetmap France | &copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>',
        maxZoom: 20,
      }),
      maxBounds: [
        [56.979041, 19.577637],
        [52.933327, 28.586426]
      ],
      zoomSnap: 0.5,
    });

    var tracks = $map.data('tracks');

    tracks.forEach(function (track) {
      var route = track.route;
      var isSpeedTrack = track.kind === 'speed' || track.kind === 'limited';

      var polyline = L.polyline(route, {
        color: getTrackColor(track.kind),
        opacity: isSpeedTrack ? 1 : 0.3,
      });

      var $tooltip = $('.absolute-tooltip[data-id=' + track.id + ']');

      var startPosition = route[0];
      var endPosition = route[route.length - 1];

      if (isSpeedTrack) {
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
        route.forEach(function(point) { L.marker(point).addTo(map) });
      }

      function popupText (name, position) {
        var speedLimit = track.kind === 'limited' ? '<br>Speed limit: ' + track.speed_limit : '';

        return track.name + ' ' + track.kind + ' ' + name + '<br>Position:' + position.join(',') + '<br>Track length: ' + track.length_in_km + speedLimit;
      }
    });

    // var randomRoute = ;
    // L.polyline(randomRoute, {
    //   color: 'green',
    //   opacity: 1,
    //   width: 10,
    // }).addTo(map);

    map.fitBounds(L.polyline(_.flatten(tracks.map(function (track) { return track.route }))).getBounds());
  }

  function getTrackColor (kind) {
    switch (kind) {
      case 'speed':
        return 'red';
      case 'passage':
        return 'blue';
      case 'limited':
        return 'black';
    }
  }
}
