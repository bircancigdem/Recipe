import SwiftUI

struct ContentView: View {
    @State private var image: UIImage? = nil
    @State private var isLoading = true
    
    var body: some View {
        ZStack {
            // Arka plan rengi
            Color.white.edgesIgnoringSafeArea(.all) // Tam ekran arka plan rengi
            
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit) // Resmi orantılı olarak ayarla
                    .frame(width: 200, height: 200) // Resmin boyutunu ayarlayın
                    .cornerRadius(10) // Köşeleri yuvarlat
                    .padding() // Etrafında biraz boşluk bırak
            } else if isLoading {
                Color.clear // Arka planı temiz tutmak için
            } else {
                Text("Resim yüklenemedi.")
                    .foregroundColor(.red)
            }
            
            // Yükleniyor metni
            if isLoading {
                ProgressView("Yükleniyor...")
                    .padding()
                    .background(Color.white.opacity(0.8)) // Açık bir arka plan
                    .cornerRadius(10)
                    .foregroundColor(.black)
                    .font(.headline)
            }
        }
        .onAppear {
            loadImage()
        }
    }

    private func loadImage() {
        let imageId = "66fe6e3568ca4b56a7e02ccd" // ID'yi buraya yazın
        let imageUrl = "http://192.168.1.2:3000/images/\(imageId)" // IP adresinizi buraya yazın

        guard let url = URL(string: imageUrl) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                print("Hata: \(error?.localizedDescription ?? "Unknown error")")
                DispatchQueue.main.async {
                    isLoading = false
                }
                return
            }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
                self.isLoading = false
            }
        }
        
        task.resume()
    }
}

#Preview {
    ContentView()
}

