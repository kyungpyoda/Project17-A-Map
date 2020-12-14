//
//  MainViewController+NMFOverlayImageDataSource.swift
//  NaverMapA
//
//  Created by 박태희 on 2020/11/26.
//

import Foundation
import NMapsMap

extension MainViewController: NMFOverlayImageDataSource {
    func view(with overlay: NMFOverlay) -> UIView {
        let markerOverlay = overlay as? NMFMarker
        let markerView = UIImageView(frame: CGRect(x: 0, y: 0, width: markerOverlay?.iconImage.imageWidth ?? 0, height: markerOverlay?.iconImage.imageHeight ?? 0))
        markerView.image = markerOverlay?.iconImage.image.withTintColor(markerOverlay?.iconTintColor ?? .green)
        return markerView
    }
}

extension MainViewController: NMFMapViewCameraDelegate {
    
    func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int, animated: Bool) {
        DispatchQueue.main.async {
            guard let viewModel = self.viewModel else { return }
            let coordBounds = self.naverMapView.coordBounds
            let filtedPlaces = viewModel.fetchedPlaces(with: coordBounds)
            self.zoomLevelCheck = mapView.zoomLevel
            if self.$zoomLevelCheck {
                viewModel.updatePlacesAndAnimation(places: filtedPlaces, bounds: self.naverMapView.coordBounds) {
                    DispatchQueue.main.async {
                        if self.naverMapView.selectedLeafMarker == nil {
                            return
                        }
                        var findLeap = false
                        for marker in self.naverMapView.clusterMarkers {
                            if marker.position.lat == self.naverMapView.selectedLeafMarker?.position.lat && marker.position.lng == self.naverMapView.selectedLeafMarker?.position.lng {
                                self.naverMapView.selectedLeafMarker = marker
                                findLeap = true
                                break
                            }
                        }
                        if !findLeap {
                            self.naverMapView.selectedLeafMarker = nil
                        }
                    }
                }
            }
        }
    }
    
    func updateMapView() {
        DispatchQueue.main.async {
            guard let viewModel = self.viewModel else { return }
            let coordBounds = self.naverMapView.coordBounds
            let filtedPlaces = viewModel.fetchedPlaces(with: coordBounds)
            viewModel.updatePlaces(places: filtedPlaces, bounds: coordBounds) {}
        }
    }
}
