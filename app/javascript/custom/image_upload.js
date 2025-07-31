document.addEventListener("turbo:load", function() {
  document.addEventListener("change", function(event) {
    let image_upload = document.querySelector('#micropost_image');
    if (image_upload && image_upload.files[0]) {
      const file = image_upload.files[0];
      const size_in_megabytes = file.size/1024/1024;
      const max_size_mb = parseInt(image_upload.dataset.maxSizeMb) || 5;
      const allowed_types = image_upload.dataset.allowedTypes ?
        image_upload.dataset.allowedTypes.split(',') :
        ['image/jpeg', 'image/gif', 'image/png'];

      if (!allowed_types.includes(file.type)) {
        alert(I18n.t('microposts.image_upload.invalid_file_type'));
        image_upload.value = "";
        return;
      }

      if (size_in_megabytes > max_size_mb) {
        alert(I18n.t('microposts.image_upload.file_too_large'));
        image_upload.value = "";
      }
    }
  });
});
