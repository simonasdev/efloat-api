function initializeTimelineMap() {
  var $map = $('#timeline-map');

  if ($map.length) {
    var map = L.map(
      $map.attr('id'),
      _.assign({}, defaultMapOptions(), {
        timeDimension: true,
        timeDimensionControl: true,
      })
    );

    addTracksToMap($map.data('tracks'), map);

    $('#refresh-data').on('click', replaceDataLinesForMap.bind(null, $map.data('url'), map));
  }
}

function initializeConnectedDevices () {
  if ($('#connected-devices').length) {
    window.connectedDevicesInterval = window.setInterval(function () {
      $.get('/devices/connected', function (response) {
        $('#connected-devices').html(response);
      });
    }, 2000);
  } else if (window.connectedDevicesInterval) {
    window.clearInterval(window.connectedDevicesInterval);
    window.connectedDevicesInterval = null;
  }
}

function replaceDataLinesForMap(url, map) {
  return $.get(url, function (response) {
    var coordinates = [],
        times = [],
        speeds = [],
        attributes,
        data = response.data;

    for (var i = 0, len = data.length; i < len; i++) {
      attributes = data[i].attributes;

      coordinates.push([attributes.latitude, attributes.longitude]);
      times.push(attributes.timestamp);
      speeds.push(attributes.speed);
    }

    var layer = L.geoJSON({
      "type": "Feature",
      "geometry": {
        "type": "MultiPoint",
        "coordinates": coordinates
      },
      "properties": {
        "time": times,
        speed: speeds
      }
    });

    L.timeDimension.layer.geoJson(layer, {
      addlastPoint: true,
      updateTimeDimension: true,
      updateTimeDimensionMode: 'replace',
    }).addTo(map);
  });
}
