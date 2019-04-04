// These util functions will be available for all subpages globally.


/**
 * Copy from HTML input field to clipboard.
 * An example from: https://clipboardjs.com
 *
 * @param  {string} input_field Name of the input field
 */
function copyToClipboard(input_field) {
  var copyText = document.getElementById(input_field);
  copyText.select();
  document.execCommand("copy");
}
