//
//  RMEpisodeDetailViewModel.swift
//  RickAndMorty
//
//  Created by Yunus Emre Berdibek on 12.12.2023.
//

import Foundation

protocol RMEpisodeDetailViewModelDelegate: AnyObject {
    func didFetchEpisodeDetails()
}

final class RMEpisodeDetailViewModel {
    // MARK: - Properties

    public private(set) var cellViewModels: [SectionType] = []
    public var delegate: RMEpisodeDetailViewModelDelegate?
    private let endpointUrl: URL?

    enum SectionType {
        case information(viewModels: [RMEpisodeInfoCollectionViewCellViewModel])
        case characters(viewModels: [RMCharacterCollectionViewCellViewModel])
    }

    private var dataTuple: (episode: RMEpisode, characters: [RMCharacter])? {
        didSet {
            createCellViewModels()
            delegate?.didFetchEpisodeDetails()
        }
    }

    // MARK: - Init

    init(url: URL?) {
        self.endpointUrl = url
    }

    public func character(at index: Int) -> RMCharacter? {
        guard let dataTuple = dataTuple else {
            return nil
        }
        return dataTuple.characters[index]
    }

    public func fetchEpisodeData() {
        guard let url = endpointUrl, let request = RMRequest(url: url) else {
            return
        }
        RMService.shared.execute(request, expecting: RMEpisode.self) { [weak self] result in
            switch result {
            case .success(let model):
                self?.fetchRelatedCharacters(episode: model)
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }

    private func createCellViewModels() {
        guard let dataTuple = dataTuple else { return }
        let episode = dataTuple.episode
        let characters = dataTuple.characters

        var createdString = episode.created
        if let createdDate = RMCharacterInformationCollectionViewCellViewModel.dateFormatter.date(from: episode.created) {
            createdString = RMCharacterInformationCollectionViewCellViewModel.shortDateFormatter.string(from: createdDate)
        }

        cellViewModels = [
            .information(viewModels: [
                .init(title: "Episode Name", value: episode.name),
                .init(title: "Air Date", value: episode.air_date),
                .init(title: "Episode", value: episode.episode),
                .init(title: "Created", value: createdString)
            ]),
            .characters(viewModels: characters.compactMap {
                RMCharacterCollectionViewCellViewModel(
                    characterName: $0.name,
                    characterStatus: $0.status,
                    characterImageURL: URL(string: $0.image))
            })
        ]
    }

    private func fetchRelatedCharacters(episode: RMEpisode) {
        let requests: [RMRequest] = episode.characters.compactMap {
            URL(string: $0)
        }.compactMap {
            RMRequest(url: $0)
        }
        // 10 of parallel requests.
        // Notified once all done.
        let group = DispatchGroup()
        var characters: [RMCharacter] = []
        for request in requests {
            group.enter() // +20
            RMService.shared.execute(request, expecting: RMCharacter.self) { result in
                defer {
                    group.leave() // -20
                }
                switch result {
                case .success(let model):
                    characters.append(model)
                case .failure:
                    break
                }
            }
        }
        group.notify(queue: .main) {
            self.dataTuple = (episode: episode, characters: characters)
        }
    }
}

/*
 DispatchGroup oluşturulur. Bu, grup içindeki işlemlerin tamamlanmasını beklemek için kullanılır.
 RMCharacter türünden bir dizi oluşturulur. Bu dizi, her bir asenkron işlemden elde edilen RMCharacter modellerini içerecek.
 requests adlı bir döngüde dönülür. Her bir döngü adımında, bir DispatchGroup işlemine giriş yapılır (group.enter()).
 Ardından, RMService.shared.execute fonksiyonu çağrılır. Bu fonksiyon, belirli bir isteği işler ve sonucu bir kapatma (closure) içinde geri döner.
 Kapatma içinde, sonuç başarılı ise (case .success), elde edilen model characters dizisine eklenir. Başarısızlık durumunda (case .failure), herhangi bir şey yapılmaz.
 Her döngü adımının sonunda, defer bloğu içinde bir group.leave() çağrısı yapılır. Bu, o döngü adımındaki işlemin tamamlandığını ve DispatchGroup'un bir adım geriye gitmesi gerektiğini belirtir.
 Bu kod, bir dizi isteği (requests) asenkron olarak işler ve her bir isteğin başarılı veya başarısız olup olmadığını takip eder. DispatchGroup kullanarak tüm işlemlerin tamamlandığını bekleyebilirsiniz. characters dizisi, başarılı olan her isteğin sonucunu içerir.
 */
