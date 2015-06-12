@dateFormat = (date) ->
  d = new Date(date)
  d.getDate() + '-' + d.getMonth() + '-' + d.getFullYear()

@marketOpen = ->
  today = new Date()
  return false if (today.getDay() == 6 || today.getDay() == 0)
  time0930 = new Date().setHours(6,30,0,0)
  time1600 = new Date().setHours(13,0,0,0)
  return true if (today >= time0930 && today <= time1600)
  return false