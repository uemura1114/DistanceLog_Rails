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
var api_read;
var watch_id;
var lastUpdateTime;
var minFrequency = 2 * 1000;

var st_img_url = "https://chart.googleapis.com/chart?chst=d_map_pin_letter_withshadow&chld=S|ff0000|ffff00";
var ed_img_url = "https://chart.googleapis.com/chart?chst=d_map_pin_letter_withshadow&chld=E|39A751|ffff00";

function initMap(){
  if (!navigator.geolocation) {
    alert('Geolocation not supported');
    return;
  }
  api_read = 1;

  slat = document.getElementById("distance_st_lat");
  slng = document.getElementById("distance_st_lng");
  elat = document.getElementById("distance_ed_lat");
  elng = document.getElementById("distance_ed_lng");

  getCenterPoint(openMaps);
}

function ButtonClickSt(callback) {
  slat.value = current_lat;
  slng.value = current_lng;
  callback();
}
    
function ButtonClickEd(callback){
  elat.value = current_lat;
  elng.value = current_lng;
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
    // icon: {
    //   fillColor: "#E74135",                //塗り潰し色
    //   fillOpacity: 0.6,                    //塗り潰し透過率
    //   path: google.maps.SymbolPath.CIRCLE, //円を指定
    //   scale: 10,                           //円のサイズ
    //   strokeColor: "#FFFFFF",              //枠の色
    //   strokeWeight: 1.0                    //枠の透過率
    // },
    // label: {
    //   text: 'S',                           //ラベル文字
    //   color: '#FFFFFF',                    //文字の色
    //   fontSize: '0.6rem'                     //文字のサイズ
    // }
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
    // icon: {
    //   fillColor: "#39A751",                //塗り潰し色
    //   fillOpacity: 0.6,                    //塗り潰し透過率
    //   path: google.maps.SymbolPath.CIRCLE, //円を指定
    //   scale: 10,                           //円のサイズ
    //   strokeColor: "#FFFFFF",              //枠の色
    //   strokeWeight: 1.0                    //枠の透過率
    // },
    // label: {
    //   text: 'E',                           //ラベル文字
    //   color: '#FFFFFF',                    //文字の色
    //   fontSize: '0.6rem'                     //文字のサイズ
    // }
  };
  if(end_maker) {
    end_maker.setMap(null);
  }
  end_maker = new google.maps.Marker(markerOptions);
}

watch_id = navigator.geolocation.watchPosition(success);

function success(position) {
  if (api_read != 1){
    return false;
  }
  var now = new Date();
  if(lastUpdateTime && now.getTime() - lastUpdateTime.getTime() < minFrequency) {
    return;
  }
  lastUpdateTime = now;

  current_lat = position.coords.latitude;
  current_lng = position.coords.longitude;
  current_lat = Math.floor(current_lat * 1000000) / 1000000;
  current_lng = Math.floor(current_lng * 1000000) / 1000000;

  if (start_maker) {
    var north = Math.max(current_lat, start_maker.getPosition().lat());
    var south = Math.min(current_lat, start_maker.getPosition().lat());
    var east = Math.max(current_lng, start_maker.getPosition().lng());
    var west = Math.min(current_lng, start_maker.getPosition().lng());
    latLngBounds = new google.maps.LatLngBounds(
      new google.maps.LatLng(south, west),
      new google.maps.LatLng(north, east)
      );
    map.fitBounds(latLngBounds, 17);
  }else {
    map_center_lat = current_lat;
    map_center_lng = current_lng;
    map.panTo(new google.maps.LatLng(map_center_lat, map_center_lng));
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


