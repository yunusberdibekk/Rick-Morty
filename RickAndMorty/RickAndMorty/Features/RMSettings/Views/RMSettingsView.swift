//
//  RMSettingsView.swift
//  RickAndMorty
//
//  Created by Yunus Emre Berdibek on 23.12.2023.
//

import SwiftUI

struct RMSettingsView: View {
    let viewModel: RMSettingsViewModel
    init(viewModel: RMSettingsViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        List(viewModel.cellViewModels) { viewModel in
            HStack {
                if let image = viewModel.image {
                    Image(uiImage: image)
                        .resizable()
                        .renderingMode(.template)
                        .foregroundStyle(.white)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .padding(8)
                        .background(Color(viewModel.iconContainerColor))
                        .clipShape(.rect(cornerRadius: 6))

                    Text(viewModel.title)
                        .padding(.leading, 4)

                    Spacer()
                }
            }
            .padding(.bottom, 3)
            .onTapGesture {
                viewModel.onTapHandler(viewModel.type)
            }
        }
    }
}

#Preview {
    RMSettingsView(viewModel: .init(cellViewModels: RMSettingsOption.allCases.compactMap {
        RMSettingsCellViewModel(type: $0, onTapHandler: { _ in })
    }))
}
