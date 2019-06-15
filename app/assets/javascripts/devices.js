function initializeTimelineMap() {
  var $map = $('#timeline-map');

  if ($map.length) {
    var map = L.map(
      $map.attr('id'),
      _.assign({}, defaultMapOptions(), {
        timeDimension: true
      })
    );

    var timeDimensionControl = new L.Control.TimeDimension({
      minSpeed: 1,
      speedStep: 1,
      maxSpeed: 20,
      playReverseButton: true
    });
    map.addControl(timeDimensionControl);
    timeDimensionControl._toggleDateUTC();

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
  var redIcon = new L.Icon({
    iconUrl: 'https://raw.githubusercontent.com/pointhi/leaflet-color-markers/master/img/marker-icon-2x-red.png',
    shadowUrl: 'https://cdnjs.cloudflare.com/ajax/libs/leaflet/0.7.7/images/marker-shadow.png',
    iconSize: [25, 40],
    iconAnchor: [12, 40],
    popupAnchor: [1, -20],
    tooltipAnchor: [12, -20],
    shadowSize: [40, 40]
  });

  var params = '&timestamp_from=' + $('#timestamp_from').val() + '&timestamp_until=' + $('#timestamp_until').val()

  return $.get(url + params, function (response) {
    var coordinates = [],
        times = [],
        speeds = [],
        attributes,
        data = response.data;

    for (var i = 0, len = data.length; i < len; i++) {
      attributes = data[i].attributes;

      coordinates.push([attributes.longitude, attributes.latitude]);
      times.push(attributes.timestamp);
      speeds.push(attributes.speed);
    }

    var marker;

    var layer = L.geoJSON({
      "type": "Feature",
      "geometry": {
        "type": "MultiPoint",
        "coordinates": coordinates
      },
      "properties": {
        "times": times,
        speed: speeds
      }
    }, {
      pointToLayer: function (feature, latLng) {
        if (marker) {
          marker.setLatLng(latLng)
        } else {
          marker = L.marker(latLng, { icon: redIcon })
        }

        return marker;
      },
      onEachFeature: function (feature, layer) {
        var speed = feature.properties.speed[timeDimension && timeDimension._map.timeDimension._currentTimeIndex || 0];

        layer.bindTooltip(Math.round(speed) + ' km/h', { permanent: true });
      }
    });

    var timeDimension = L.timeDimension.layer.geoJson(layer, {
      updateTimeDimension: true,
      updateTimeDimensionMode: 'replace',
    });

    timeDimension.addTo(map);
  });
}
