import SwiftUI

struct ContentView: View {
    @State private var memories: [Memory] = loadMemories()
    @State private var showAddMemory = false
    @State private var searchText = ""
    @State private var selectedCategory: MemoryCategory?
    @State private var sortOrder: SortOrder = .newest
    @State private var isGridView = true
    
    enum SortOrder {
        case newest, oldest
    }
    
    var filteredMemories: [Memory] {
        let filtered = memories.filter { memory in
            let matchesSearch = searchText.isEmpty ||
                memory.title.localizedCaseInsensitiveContains(searchText) ||
                memory.description.localizedCaseInsensitiveContains(searchText)
            
            let matchesCategory = selectedCategory == nil || memory.category == selectedCategory
            
            return matchesSearch && matchesCategory
        }
        
        return filtered.sorted { first, second in
            switch sortOrder {
            case .newest:
                return first.date > second.date
            case .oldest:
                return first.date < second.date
            }
        }
    }
    
    var body: some View {
        NavigationView {
            Group {
                VStack(spacing: 0) {
                    // Kategori Filtreleme
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            CategoryButton(title: "Tümü", isSelected: selectedCategory == nil) {
                                selectedCategory = nil
                            }
                            ForEach(MemoryCategory.allCases, id: \.self) { category in
                                CategoryButton(
                                    title: category.rawValue,
                                    iconName: category.iconName,
                                    color: category.color,
                                    isSelected: selectedCategory == category
                                ) {
                                    selectedCategory = category
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical, 8)
                    .background(Color(.systemBackground))
                    if isGridView {
                        // Grid Görünümü
                        ScrollView {
                            LazyVGrid(columns: [
                                GridItem(.flexible(), spacing: 16),
                                GridItem(.flexible(), spacing: 16)
                            ], spacing: 16) {
                                ForEach(filteredMemories) { memory in
                                    if let index = memories.firstIndex(where: { $0.id == memory.id }) {
                                        NavigationLink(destination: MemoryDetailView(memory: $memories[index]) { updatedMemory in
                                            memories[index] = updatedMemory
                                            saveMemories(memories)
                                        }) {
                                            MemoryCard(memory: memory) {
                                                deleteMemory(at: IndexSet(integer: index))
                                            }
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity)
                        }
                        .background(Color(.systemGroupedBackground))
                    } else {
                        // Liste Görünümü
                        List {
                            ForEach(filteredMemories) { memory in
                                if let index = memories.firstIndex(where: { $0.id == memory.id }) {
                                    NavigationLink(destination: MemoryDetailView(memory: $memories[index]) { updatedMemory in
                                        memories[index] = updatedMemory
                                        saveMemories(memories)
                                    }) {
                                        MemoryRow(memory: memory)
                                    }
                                }
                            }
                            .onDelete(perform: deleteMemory)
                        }
                    }
                }
                .navigationTitle("Anılarımız 💖")
                .searchable(text: $searchText, prompt: "Anılarında ara...")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Menu {
                            Button(action: { sortOrder = .newest }) {
                                Label("En Yeni", systemImage: "arrow.down")
                            }
                            Button(action: { sortOrder = .oldest }) {
                                Label("En Eski", systemImage: "arrow.up")
                            }
                            Divider()
                            Button(action: { isGridView.toggle() }) {
                                Label(isGridView ? "Liste Görünümü" : "Grid Görünümü", 
                                      systemImage: isGridView ? "list.bullet" : "square.grid.2x2")
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            showAddMemory = true
                        }) {
                            Image(systemName: "plus")
                        }
                    }
                }
                .sheet(isPresented: $showAddMemory) {
                    AddMemoryView(memories: $memories)
                }
            }
            // Sağ taraf için hoşgeldin ekranı
            Text("""
Bazen bir bakışın, bazen bir gülüşün yetiyor mutlu olmama.
İşte burada, seninle yaşadığım o güzel anları biriktirmek istiyorum.
Her yeni anı, sevgimize eklenen yepyeni bir renk gibi.
İyi ki varsın, iyi ki benimlesin.
""")
                .multilineTextAlignment(.center)
                .font(.title3)
                .foregroundColor(.secondary)
                .padding()
        }
    }

    func deleteMemory(at offsets: IndexSet) {
        for index in offsets {
            if let imagePath = memories[index].imagePath {
                try? FileManager.default.removeItem(atPath: imagePath)
            }
        }
        memories.remove(atOffsets: offsets)
        saveMemories(memories)
    }
}

struct MemoryCard: View {
    let memory: Memory
    let onDelete: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Fotoğraf
            ZStack(alignment: .topTrailing) {
                if let path = memory.imagePath,
                   let uiImage = UIImage(contentsOfFile: path) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 120)
                        .clipped()
                } else {
                    Image("memory1")
                        .resizable()
                        .scaledToFill()
                        .frame(height: 120)
                        .clipped()
                }
            }
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Image(systemName: memory.category.iconName)
                        .foregroundColor(memory.category.color)
                    Text(memory.title)
                        .font(.headline)
                        .lineLimit(1)
                    Spacer()
                    Button(action: onDelete) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                }
                Text(memory.date, style: .date)
                    .font(.caption)
                    .foregroundColor(.gray)
                Text(memory.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            .padding(8)
        }
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 5)
        .frame(maxWidth: .infinity, minHeight: 180, maxHeight: 220)
    }
}

struct MemoryRow: View {
    let memory: Memory
    
    var body: some View {
        HStack {
            Image(systemName: memory.category.iconName)
                .foregroundColor(memory.category.color)
                .font(.title2)
                .frame(width: 30)
            
            if let path = memory.imagePath,
               let uiImage = UIImage(contentsOfFile: path) {
                Image(uiImage: uiImage)
                    .resizable()
                    .frame(width: 80, height: 80)
                    .cornerRadius(10)
            } else {
                Image("memory1")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .cornerRadius(10)
            }

            VStack(alignment: .leading) {
                Text(memory.title)
                    .font(.headline)
                Text(memory.date, style: .date)
                    .font(.caption)
                    .foregroundColor(.gray)
                Text(memory.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
        }
        .padding(.vertical, 8)
    }
}

struct CategoryButton: View {
    let title: String
    var iconName: String? = nil
    var color: Color = .gray
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                if let iconName = iconName {
                    Image(systemName: iconName)
                        .foregroundColor(isSelected ? .white : color)
                }
                Text(title)
                    .foregroundColor(isSelected ? .white : .primary)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isSelected ? color : Color.gray.opacity(0.1))
            )
        }
    }
}

func saveMemories(_ memories: [Memory]) {
    if let encoded = try? JSONEncoder().encode(memories) {
        UserDefaults.standard.set(encoded, forKey: "memories")
    }
}

func loadMemories() -> [Memory] {
    if let data = UserDefaults.standard.data(forKey: "memories"),
       let decoded = try? JSONDecoder().decode([Memory].self, from: data) {
        return decoded
    }
    return []
}
