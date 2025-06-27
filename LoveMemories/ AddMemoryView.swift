import SwiftUI

struct AddMemoryView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var memories: [Memory]

    @State private var title = ""
    @State private var description = ""
    @State private var date = Date()
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage? = nil

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Anı Başlığı")) {
                    TextField("Başlık girin", text: $title)
                        .autocapitalization(.sentences)
                }

                Section(header: Text("Açıklama")) {
                    TextEditor(text: $description)
                        .frame(minHeight: 100)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3)))
                }

                Section(header: Text("Tarih")) {
                    DatePicker("Tarih Seç", selection: $date, displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .frame(minHeight: 350)
                }

                Section(header: Text("Seçilen Görsel")) {
                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .cornerRadius(10)
                    } else {
                        Text("Henüz görsel seçilmedi.")
                            .foregroundColor(.secondary)
                    }

                    Button("📸 Fotoğraf Seç") {
                        showImagePicker = true
                    }
                    .buttonStyle(.bordered)
                }

                Section {
                    Button("💾 Kaydet") {
                        var imagePath: String? = nil

                        if let image = selectedImage,
                           let data = image.jpegData(compressionQuality: 0.8) {
                            let filename = UUID().uuidString + ".jpg"
                            let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                                .appendingPathComponent(filename)

                            try? data.write(to: url)
                            imagePath = url.path
                        }

                        let newMemory = Memory(title: title, description: description, date: date, imagePath: imagePath)
                        memories.append(newMemory)
                        saveMemories(memories)
                        dismiss()
                    }
                    .disabled(title.isEmpty || description.isEmpty)
                    .tint(.green)
                }
            }
            .navigationTitle("Yeni Anı Ekle")
            .navigationBarTitleDisplayMode(.inline)
            .fullScreenCover(isPresented: $showImagePicker) {
                ImagePicker(image: $selectedImage)
            }
        }
    }
}
