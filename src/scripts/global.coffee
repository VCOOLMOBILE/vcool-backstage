global.$ = global.jQuery = require('jquery');
require 'bootstrap';
Sortable = require 'sortablejs';

readURL = (input) ->
  if input.files and input.files[0]
    reader = new FileReader
    reader.onload = (e) ->
      $(input).prev().children().attr 'src', e.target.result
      return
    reader.readAsDataURL input.files[0]
  return

scriptImageUpdate = ->
  if $('.script-photo').length != 0
    $('.script-photo-upload').change ->
      readURL this
      return

storyboardImageUpdate = ->
  if $('.storyboard-photo').length != 0
    $('.storyboard-photo-upload').change ->
      readURL this
      return

storyboardDataDragAndDrop = ->
  if $('#storyboardData').length != 0
    Sortable.create(storyboardData)
    return

scriptClassDataDragAndDrop = ->
  if $('#scriptClassData').length != 0
    Sortable.create(scriptClassData)
    return

storyboardClassDataDragAndDrop = ->
  if $('#storyboardClassData').length != 0
    Sortable.create(storyboardClassData)
    return

$(document).ready ->
  scriptImageUpdate()
  storyboardImageUpdate()
  storyboardDataDragAndDrop()
  scriptClassDataDragAndDrop()
  storyboardClassDataDragAndDrop()
  return