//
//  ContentView.swift
//  datasVideo
//
//  Created by duverney muriel on 11/01/24.
//

import SwiftUI
import SwiftData
import AVKit

struct ContentView: View {
    @Environment(\.modelContext) var moc
    @Query(animation: .smooth) var container: [Container]
    
    //---------------
    @State private var device = UIDevice()
    @State  var showAdd: Bool = true
    var multiDevice: [GridItem] {
        if self.device.userInterfaceIdiom == .pad {
            return Array(repeating: GridItem(.fixed(250)), count: 4)
        } else{
            return Array(repeating: GridItem(.flexible()), count: 2)
        }
    }
    
    //    ---------
    var body: some View {
        
        
        NavigationStack {
            ScrollView(.vertical,showsIndicators: false) {
                LazyVGrid(columns: multiDevice) {
                    
                    
                    ForEach(container, id: \.id){ cont in
                        VStack(alignment: .leading, spacing: 8){
                            if let videoURL = cont.videoURL{
                                VideoPlayer(player: AVPlayer(url: videoURL))
                                    .aspectRatio(contentMode: .fit)
                            }
                            if let imgData = cont.imgData {
                                Image(uiImage: UIImage(data: imgData)!)
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    .shadow(radius: 4)
                            }
                            //                            MARK: HSheart.
                            HStack{
                                Text(cont.title).font(.headline).fontWeight(.semibold)
                                Spacer()
                                Button {
                                    cont.likes.toggle()
                                } label: {
                                    Image(systemName: cont.likes ? "heart.fill":"heart")
                                }.foregroundStyle(cont.likes ? .red:.gray)
                            
                                
                            }
                            Text(cont.date, style: .date)
                                .font(.caption2)
                                .foregroundStyle(.gray)
                            Text(cont.detail).font(.subheadline)
                                .foregroundStyle(.gray)
                           
                        } .padding()
                            .background()
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(color: .gray, radius: 3, x: 1, y: 1)
                    }
                }.navigationTitle("Container")
                    .toolbar{
                        Button {
                            self.showAdd.toggle()
                        } label: {
                            Image(systemName: "video.badge.plus")
                        }
                    }
                    .sheet(isPresented: self.$showAdd) {
//                            newcontent
                        NewContents()
                    }
            }
        }.padding(2)
    }
}
#Preview {
    ContentView()
        .modelContainer(for: Container.self)
}
