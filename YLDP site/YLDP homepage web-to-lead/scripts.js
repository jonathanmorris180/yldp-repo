(function validateForm() {
  'use strict';
  window.addEventListener('load', function() {
    // Fetch the form
    var form = document.querySelector('.needs-validation');
    // Prevent submission
    if(form != null) {
      form.addEventListener('submit', function(event) {
        if (form.checkValidity() === false) {
          event.preventDefault();
          event.stopPropagation();
        }
        form.classList.add('was-validated');
      }, false);
    }
  }, false);
})();