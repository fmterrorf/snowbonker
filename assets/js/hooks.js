import "leaflet-rotatedmarker";
export const Map = {
  mounted() {
    const map = L.map('map', { scrollWheelZoom: 'center' }).
      setView([52.1279, -106.6702], 7);

    L.maplibreGL({
      style: 'https://tiles.openfreemap.org/styles/liberty',
    }).addTo(map)


    const geoJSONLayer = L.geoJSON({ "type": "FeatureCollection", "features": [] }, {
      pointToLayer: function(geoJSONPoint) {

        const plowIcon = L.icon({
          iconUrl: 'images/plow.svg',
          iconSize: [38, 38],
          iconAnchor: [22, 10]
        });
        const marker = L.marker(geoJSONPoint.geometry.coordinates, {
          icon: plowIcon,
          rotationAngle: Math.floor(Math.random() * 360)
        });
        marker.bindTooltip(geoJSONPoint.properties.label, {
          direction: 'right',
          // permanent: true,
          className: 'point'
        });

        return marker;
      }
    }).addTo(map);

    this.handleEvent("locations", (data) => {
      const features = data.locations.map(item => {
        return {
          "type": "Feature",
          "properties": { "label": item.label },
          "geometry": {
            "type": "Point",
            "coordinates": item.location
          }
        }
      });
      geoJSONLayer.clearLayers();
      geoJSONLayer.addData(features);
    })
  }
}
