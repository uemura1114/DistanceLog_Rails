'use strict';

let slat, slng, elat, elng, slat_1, slng_1;
var center_lat, center_lng;
var current_lat, current_lng;
var map_center_lat, map_center_lng;
var latLngBounds;

var map;
var current_maker;
var start_maker;
var end_maker;
var tgt_marker;
var watch_id;
var lastUpdateTime;
var minFrequency = 0.5 * 1000;

var st_img_url = "https://chart.googleapis.com/chart?chst=d_map_pin_letter_withshadow&chld=S|ff0000|ffff00";
var ed_img_url = "https://chart.googleapis.com/chart?chst=d_map_pin_letter_withshadow&chld=E|39A751|ffff00";

function initMap(){
  if (!navigator.geolocation) {
    alert('Geolocation not supported');
    return;
  }

  if (!watch_id) {
    watch_id = navigator.geolocation.watchPosition(success);
  }

  slat = document.getElementById("distance_st_lat");
  slng = document.getElementById("distance_st_lng");
  elat = document.getElementById("distance_ed_lat");
  elng = document.getElementById("distance_ed_lng");

  getCenterPoint(openMaps);
}

function ButtonClickSt(callback) {
  if (tgt_marker) {
    slat.value = Math.floor(tgt_marker.getPosition().lat() * 1000000) / 1000000;
    slng.value = Math.floor(tgt_marker.getPosition().lng() * 1000000) / 1000000;
  }else {
    slat.value = current_lat;
    slng.value = current_lng;
  }
  callback();
}
    
function ButtonClickEd(callback){
  if (tgt_marker) {
    elat.value = Math.floor(tgt_marker.getPosition().lat() * 1000000) / 1000000;
    elng.value = Math.floor(tgt_marker.getPosition().lng() * 1000000) / 1000000;
  }else {
    elat.value = current_lat;
    elng.value = current_lng;
  }
  callback();
}

function getCenterPoint(callback) {
  navigator.geolocation.getCurrentPosition(
    function(position){
      center_lat = position.coords.latitude;
      center_lng = position.coords.longitude;
      center_lat = Math.floor(center_lat * 1000000) / 1000000;
      center_lng = Math.floor(center_lng * 1000000) / 1000000;
      callback();
    },
    function(error){
      switch(error.code) {
        case 1: //PERMISSION_DENIED
          alert("位置情報の利用が許可されていません");
        break;
        case 2: //POSITION_UNAVAILABLE
          alert("現在位置が取得できませんでした");
        break;
        case 3: //TIMEOUT
          alert("タイムアウトになりました");
        break;
        default:
          alert("その他のエラー(エラーコード:"+error.code+")");
        break;
      }
    }
  );
}

function openMaps() {
  var mapPosition = {lat: center_lat, lng: center_lng};
  var mapArea = document.getElementById('maps');
  var mapOptions = {
      center: mapPosition,
      zoom: 17.5,
      mapTypeId: google.maps.MapTypeId.SATELLITE,
      mapTypeControl: false,
      zoomControl: false,
      streetViewControl: false,
      scaleControl: true,
      fullscreenControl: false,
      gestureHandling: 'greedy',
      rotateControl: false,
      mapTypeControlOptions:{
      mapTypeIds:[google.maps.MapTypeId.SATELLITE, google.maps.MapTypeId.ROADMAP], 
    },
  };
  map = new google.maps.Map(mapArea, mapOptions);
  createCurrentMaker();
  if(slat.value && slng.value) {
    createStartMaker();
  }
  if(elat.value && elng.value) {
    createEndMaker();
  }
}

function createCurrentMaker() {
  var markerOptions = {
    map: map,
    position:{lat: center_lat, lng: center_lng},
    icon: {
      fillColor: "#4285F4",                //塗り潰し色
      fillOpacity: 0.8,                    //塗り潰し透過率
      path: google.maps.SymbolPath.CIRCLE, //円を指定
      scale: 6,                           //円のサイズ
      strokeColor: "#FFFFFF",              //枠の色
      strokeWeight: 1.0                    //枠の透過率
    },
  };
  current_maker = new google.maps.Marker(markerOptions);
}

function createStartMaker() {
  var markerOptions = {
    map: map,
    position:{lat: parseFloat(slat.value), lng: parseFloat(slng.value)},
    icon: st_img_url
  };
  if(start_maker) {
    start_maker.setMap(null);
  }
  start_maker = new google.maps.Marker(markerOptions);
}

function createEndMaker() {
  var markerOptions = {
    map: map,
    position:{lat: parseFloat(elat.value), lng: parseFloat(elng.value)},
    icon: ed_img_url
  };
  if(end_maker) {
    end_maker.setMap(null);
  }
  end_maker = new google.maps.Marker(markerOptions);
}


function success(position) {
  var now = new Date();
  if(lastUpdateTime && now.getTime() - lastUpdateTime.getTime() < minFrequency) {
    return;
  }
  lastUpdateTime = now;

  current_lat = position.coords.latitude;
  current_lng = position.coords.longitude;
  current_lat = Math.floor(current_lat * 1000000) / 1000000;
  current_lng = Math.floor(current_lng * 1000000) / 1000000;

  if (start_maker && !tgt_marker) {
    var north = Math.max(current_lat, start_maker.getPosition().lat());
    var south = Math.min(current_lat, start_maker.getPosition().lat());
    var east = Math.max(current_lng, start_maker.getPosition().lng());
    var west = Math.min(current_lng, start_maker.getPosition().lng());
    latLngBounds = new google.maps.LatLngBounds(
      new google.maps.LatLng(south, west),
      new google.maps.LatLng(north, east)
      );
    map.fitBounds(latLngBounds, 17);
  }else if (maps && !tgt_marker) {
    map_center_lat = current_lat;
    map_center_lng = current_lng;
    map.panTo(new google.maps.LatLng(map_center_lat, map_center_lng));
  }else if (!maps) {
    initMap();
  }

  var markerOptions = {
    map: map,
    position:{lat: current_lat, lng: current_lng},
    icon: {
      fillColor: "#4285F4",                //塗り潰し色
      fillOpacity: 0.8,                    //塗り潰し透過率
      path: google.maps.SymbolPath.CIRCLE, //円を指定
      scale: 6,                           //円のサイズ
      strokeColor: "#FFFFFF",              //枠の色
      strokeWeight: 1.0                    //枠の透過率
    }
  };
  current_maker.setMap(null);
  current_maker = new google.maps.Marker(markerOptions);
}

function gpsOnOff() {
  if (tgt_marker){
    google.maps.event.clearListeners(map, 'bounds_changed');
    if(tgt_marker.map){
      tgt_marker.setMap(null);
    }
    tgt_marker = null;
    current_maker.setMap(map);
  }else {
    center_lat = map.getCenter().lat();
    center_lng = map.getCenter().lng();
    
    tgt_marker = new google.maps.Marker({
      position: {lat: center_lat, lng: center_lng},
      map: map,
      icon: {
        path: 'M -8,0 8,0 M 0,-8 0,8',
        strokeColor: "#CE0001",
        strokeWeight: 3.0,
      },
      clickable: false,
      zIndex: 10
    });
    
    tgt_marker.setMap(map);
    google.maps.event.addListener( map ,'bounds_changed',function(){
      var pos = map.getCenter();
      tgt_marker.setPosition(pos);
    });
  }
}

function confirmPoints() {
  if (end_maker && start_maker) {
    center_lat = (start_maker.getPosition().lat() + end_maker.getPosition().lat()) / 2;
    center_lng = (start_maker.getPosition().lng() + end_maker.getPosition().lng()) / 2;
    map_center_lat = current_lat;
    map_center_lng = current_lng;
    map.panTo(new google.maps.LatLng(map_center_lat, map_center_lng));

    var north = Math.max(start_maker.getPosition().lat(), end_maker.getPosition().lat());
    var south = Math.min(start_maker.getPosition().lat(), end_maker.getPosition().lat());
    var east = Math.max(start_maker.getPosition().lng(), end_maker.getPosition().lng());
    var west = Math.min(start_maker.getPosition().lng(), end_maker.getPosition().lng());
    latLngBounds = new google.maps.LatLngBounds(
      new google.maps.LatLng(south, west),
      new google.maps.LatLng(north, east)
      );
    map.fitBounds(latLngBounds, 17);
  }
}
  
function clearPoints() {
  if (start_maker && !end_maker) {
    confirm("START地点を削除しますか？");
    start_maker.setMap(null);
    start_maker = null;
  }
  if(end_maker && !start_maker) {
    confirm("END地点を削除しますか？");
    end_maker.setMap(null);
    end_maker = null;
  }
  if (start_maker && end_maker) {
    confirm("START地点とEND地点を削除しますか？");
    start_maker.setMap(null);
    end_maker.setMap(null);
    start_maker = null;
    end_maker = null;
  }
}

function showMap(){
  var st_lat = Number(document.getElementById('st_lat').value);
  var st_lng = Number(document.getElementById('st_lng').value);
  var ed_lat = Number(document.getElementById('ed_lat').value);
  var ed_lng = Number(document.getElementById('ed_lng').value);
  var center_lat = (st_lat + ed_lat)/2;
  var center_lng = (st_lng + ed_lng)/2;

  var mapPosition = {lat: center_lat, lng: center_lng};

  var mapArea = document.getElementById('maps');
  var mapOptions = {
    center: mapPosition,
    zoom: 17.5,
    mapTypeId: google.maps.MapTypeId.SATELLITE,
    mapTypeControl: false,
    zoomControl: false,
    streetViewControl: false,
    scaleControl: true,
    fullscreenControl: false,
    gestureHandling: 'cooperative',
    mapTypeControlOptions:{
      mapTypeIds:[google.maps.MapTypeId.SATELLITE, google.maps.MapTypeId.ROADMAP], 
    },
  };

  var map = new google.maps.Map(mapArea, mapOptions);

  var north = Math.max(st_lat, ed_lat);
  var south = Math.min(st_lat, ed_lat);
  var east = Math.max(st_lng, ed_lng);
  var west = Math.min(st_lng, ed_lng);
  latLngBounds = new google.maps.LatLngBounds(
    new google.maps.LatLng(south, west),
    new google.maps.LatLng(north, east)
    );
  map.fitBounds(latLngBounds, 17);

  var markerOptions_st = {
    map: map,
    position:{lat: st_lat, lng: st_lng},
    icon: st_img_url,
  };

  var markerOptions_ed = {
    map: map,
    position:{lat: ed_lat, lng: ed_lng},
    icon: ed_img_url,
  };

  var marker_st = new google.maps.Marker(markerOptions_st);
  var marker_ed = new google.maps.Marker(markerOptions_ed);
}