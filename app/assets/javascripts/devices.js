function initializeConnectedDevices () {
  if ($('#connected-devices').length) {
    window.setInterval(function () {
      $.get('/devices/connected', function (response) {
        $('#connected-devices').html(response);
      });
    }, 2000);
  }
}
