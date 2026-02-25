import UIKit

final class HomeViewController: UIViewController, UICollectionViewDelegate {
    var output: HomeViewOutput?
    
    typealias ItemIdentifireType = String
    typealias SectionIdentifireType = Int
    
    private var cellsConfigurations: [TaskCollectionViewCellConfiguration] = []
    private let searchController = UISearchController(searchResultsController: nil)
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: .createSingleListLayout())
    private lazy var dataSource = UICollectionViewDiffableDataSource<
        SectionIdentifireType, 
        ItemIdentifireType
    >(collectionView: collectionView) { [weak self] collectionView, indexPath, _ in
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TaskCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? TaskCollectionViewCell,
        let configurations = self?.cellsConfigurations else {
            assertionFailure()
            return UICollectionViewCell()
        }
        let configuration = configurations[indexPath.item]
        cell.configure(with: configuration)

        cell.onCheckButtonTapped = { [weak self] in
            self?.output?.checkButtonTapped(at: indexPath)
        }

        if configuration.isCompleted {
            self?.selectItem(at: indexPath)
        } else {
            self?.deselectItem(at: indexPath)
        }

        cell.isSelected = configuration.isCompleted
        return cell 
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewDidLoad()
        setupCollectionView()        
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.register(
            TaskCollectionViewCell.self,
            forCellWithReuseIdentifier: TaskCollectionViewCell.reuseIdentifier
        )
        collectionView.delegate = self
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = true
        collectionView.backgroundColor = .clear
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
        }
    }
    
}

extension HomeViewController: HomeViewInput {
    func setupInitialState() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.searchBarStyle = .minimal
        
        title = "Задачи"
        
        navigationItem.largeTitleDisplayMode = .always       
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
    }
    
    func displayList(items: [TaskCollectionViewCellConfiguration]) {
        cellsConfigurations = items
        let sectionToApply = 0
        var snapshot = NSDiffableDataSourceSnapshot<SectionIdentifireType, ItemIdentifireType>()
        snapshot.appendSections([sectionToApply])
        snapshot.appendItems(items.map(\.id), toSection: sectionToApply)
        dataSource.apply(snapshot)
    }

    func selectItem(at indexPath: IndexPath) {
        collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
    }

    func deselectItem(at indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
    }
}

extension HomeViewController {
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        false
    }

    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        false
    }
}
