import SwiftUI

struct MemoryDetailView: View {
    @Binding var memory: Memory
    var onSave: (Memory) -> Void
    @Environment(\.dismiss) var dismiss
    @State private var showEdit = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Başlık ve Kategori
                HStack {
                    Image(systemName: memory.category.iconName)
                        .foregroundColor(memory.category.color)
                        .font(.title)
                    Text(memory.title)
                        .font(.title)
                        .bold()
                }
                .padding(.horizontal)
                
                // Tarih
                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(.gray)
                    Text(memory.date, style: .date)
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)
                
                // Fotoğraf
                if let path = memory.imagePath,
                   let uiImage = UIImage(contentsOfFile: path) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .cornerRadius(15)
                        .shadow(radius: 5)
                        .padding(.horizontal)
                }
                
                // Açıklama
                VStack(alignment: .leading, spacing: 10) {
                    Text("Anı Detayı")
                        .font(.headline)
                        .foregroundColor(.gray)
                    
                    Text(memory.description)
                        .font(.body)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showEdit = true }) {
                    Image(systemName: "pencil")
                }
            }
        }
        .sheet(isPresented: $showEdit) {
            EditMemoryView(memory: $memory) { updatedMemory in
                self.memory = updatedMemory
                onSave(updatedMemory)
            }
        }
    }
} 