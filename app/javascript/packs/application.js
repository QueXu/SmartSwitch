//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require_tree .
document.addEventListener("DOMContentLoaded", function() {
  document.querySelectorAll('.toggle-state').forEach(function(button) {
    button.addEventListener('click', function() {
      var deviceId = this.getAttribute('data-device-id');
      var currentState = this.getAttribute('data-state');
      var newState = currentState === 'on' ? 'off' : 'on';

      fetch(`/devices/${deviceId}/toggle_state`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
        },
        body: JSON.stringify({ device: { state: newState } })
      })
      .then(response => response.json())
      .then(data => {
        if (data.success) {
          this.setAttribute('data-state', data.state);
          this.classList.toggle('btn-on', data.state === 'on');
          this.classList.toggle('btn-off', data.state === 'off');
          this.textContent = data.state.toUpperCase();
        } else {
          alert('Failed to update device state.');
        }
      });
    });
  });
});

function toggleDevice(deviceId, state) {
  const url = `/devices/${deviceId}/toggle_state`;
  const value = state ? 'on' : 'off';

  fetch(url, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'X-CSRF-Token': '<%= form_authenticity_token %>'
    },
    body: JSON.stringify({ device: { state: value } })
  })
  .then(response => {
    if (!response.ok) {
      return response.json().then(err => { throw new Error(err.error); });
    }
    return response.json();
  })
  .then(jsonData => {
    document.getElementById('message').innerText = 'Success: State changed to ' + jsonData.state.toUpperCase();
    console.log('Success:', jsonData);
  })
  .catch((error) => {
    document.getElementById('message').innerText = 'Error: ' + error.message;
    console.error('Error:', error);
  });
}
