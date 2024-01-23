//
//  NewContents.swift
//  datasVideo
//
//  Created by duverney muriel on 13/01/24.
//

import SwiftUI
import AVKit

struct NewContents: View {
    
    @Environment(\.modelContext) var moc
    @Environment(\.dismiss) var dismiss
    
    @State private var imgData : Data?
    @State private var videoURL: URL?
    @State private var title: String = ""
    @State private var detail: String = ""
    @State private var showPicker: Bool = false
    
    var body: some View {
        NavigationStack{
            
            Form{
                HStack{
                    Spacer()
                    if let videoURL = self.videoURL{
                        VideoPlayer(player: AVPlayer(url:videoURL))
                            .aspectRatio(contentMode: .fit)
                    }else if let imgData = self.imgData {
                        Image(uiImage: UIImage(data: imgData)!)
                            .resizable()
                            .scaledToFill()
                            .frame(width: UIScreen.main.bounds.width
                                   , height: UIScreen.main.bounds.height / 4)
                            .onTapGesture {
                                self.showPicker.toggle()
                            }
                    }else{
                        Image(systemName: "video")
                            .font(.system(size: 60).bold())
                            .onTapGesture {
                                withAnimation(.smooth){
                                    self.showPicker.toggle()
                                }
                            }
                    }
                    Spacer()
                    
                }
                
                TextField("título", text: $title)
                TextField("Detalles", text: $detail)
                Text("Agregar").font(.title2).fontWeight(.semibold).padding(8)
                    .frame(maxWidth: .infinity)
                    .background(.blue)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .shadow(radius: 4)
                    .onTapGesture {
                        withAnimation(.smooth) {
                            let new = Container(
                                videoURL: self.videoURL, imgData: self.imgData, title: self.title, detail: self.detail, likes: Bool(), date: Date()
                            )
//                            este inserta datos en nuestra base de datos.
                            self.moc.insert(new)
                            dismiss()
                        }
                    }
                
            }.navigationTitle("New Contents")
                .sheet(isPresented: self.$showPicker) {
                    VideoPicker(videoURL: self.$videoURL, image: self.$imgData)
                }
        }
    }
}

#Preview {
    NewContents()
}
