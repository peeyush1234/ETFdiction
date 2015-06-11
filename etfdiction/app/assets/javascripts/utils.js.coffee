@dateFormat = (date) ->
  d = new Date(date)
  d.getDate() + '-' + d.getMonth() + '-' + d.getFullYear()