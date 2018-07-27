function initializeConnectedDevices () {
  var interval;

  if ($('#connected-devices').length) {
    interval = window.setInterval(function () {
      $.get('/devices/connected', function (response) {
        $('#connected-devices').html(response);
      });
    }, 2000);
  } else if (interval) {
    window.clearInterval(interval);
    interval = null;
  }
}
