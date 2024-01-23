//
//  Model.swift
//  datasVideo
//
//  Created by duverney muriel on 11/01/24.
//

import Foundation
import SwiftUI
import SwiftData
import AVKit
import UIKit

@Model
final class Container{
    @Attribute(.externalStorage) var videoURL: URL?
    @Attribute(.externalStorage) var imgData: Data?
    var title: String
    var detail: String
    var likes: Bool
    var date: Date
    
    init(videoURL: URL? = nil, imgData: Data? = nil, title: String, detail: String, likes: Bool, date: Date) {
        self.videoURL = videoURL
        self.imgData = imgData
        self.title = title
        self.detail = detail
        self.likes = likes
        self.date = date
    }
}


struct VideoPicker: UIViewControllerRepresentable{
    @Binding var videoURL: URL?
    @Binding var image: Data?
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
//        configura para aceptar tanto video como imagenes
        picker.mediaTypes = ["public.movie","public.image"]
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        return picker
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context){}
    
        func makeCoordinator() -> Coordinator{
            Coordinator(self)
        }
        class Coordinator: NSObject, UINavigationControllerDelegate,UIImagePickerControllerDelegate{
            var parent: VideoPicker
            init(_ parent: VideoPicker) {
                self.parent = parent
            }
            func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//                MARK: manejar la selecion de video
                if let url = info[.mediaURL] as? URL{
//                    MARK: comprie el video antes de asignarlo
                    compressVideo(inputURL: url) { compressedURL in
                        DispatchQueue.main.async {
                            self.parent.videoURL = compressedURL
                            picker.dismiss(animated: true)
                        }
                        
                    }
                }
//                MARK: Manejar la seleccion de imagen
                else if let image = info[.originalImage] as? UIImage{
                    DispatchQueue.main.async {
                        let data = image.jpegData(compressionQuality: 50)
                        self.parent.image = data
                        picker.dismiss(animated: true)
                    }
                }else {
                    picker.dismiss(animated: true)
                }
            }//Video Picker
            
//            MARK: Compress este metodo permite comprimier el video antes de asignarlo..
        func compressVideo(inputURL: URL, completion: @escaping (URL?) -> Void) {
//            MARK: LA "URL" del video comprimido se  establece en el hilo principal para asegurar que la interfaz de  usuario actualice de manera segura y coherente.
            
//            MARK: "outpuURL" se establece en la misma  carpeta  que el video originial pero con un nombre diferente ("compressed.mp4")
            let outputURL = inputURL.deletingLastPathComponent().appendingPathComponent("compressed.mp4")
            let asset = AVAsset(url: inputURL)
            
            if let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetMediumQuality){
                exportSession.outputURL = outputURL
                exportSession.outputFileType = .mp4
                exportSession.exportAsynchronously {
                    switch exportSession.status {
                    case .completed:
                        completion(exportSession.outputURL)
                    default:
                        completion(nil)
                    }
                }
            }else {
                completion(nil)
            }
        }
    }
    
}
