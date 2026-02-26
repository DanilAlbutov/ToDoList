import UIKit
import SnapKit

final class HomeViewController: UIViewController, UICollectionViewDelegate {
    var output: HomeViewOutput?
    
    typealias ItemIdentifireType = String
    typealias SectionIdentifireType = Int
    
    private var cellsConfigurations: [TaskCollectionViewCellConfiguration] = []
    private let searchController = UISearchController(searchResultsController: nil)

    private let bottomBarView = HomeBottomBarView()
    
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
            self?.output?.checkButtonTapped(taskID: configuration.id)
        }
        return cell 
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBottomBar()
        setupCollectionView()
        output?.viewDidLoad()
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.register(
            TaskCollectionViewCell.self,
            forCellWithReuseIdentifier: TaskCollectionViewCell.reuseIdentifier
        )
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.snp.makeConstraints {
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide.snp.horizontalEdges)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(bottomBarView.snp.top)
        }
    }

    private func setupBottomBar() {
        view.addSubview(bottomBarView)

        bottomBarView.snp.makeConstraints {
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide.snp.horizontalEdges)
            $0.bottom.equalTo(view.snp.bottom)
            $0.height.equalTo(83)
        }
    }

    private func updateTasksCount(_ count: Int) {
        bottomBarView.updateTasksCount(count)
    }
    
}

extension HomeViewController: HomeViewInput {
    func setupInitialState() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        
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
        
        searchController.searchBar.tintColor = ToDoListAsset.Assets.primaryText.color
        searchController.searchBar.searchTextField.textColor = ToDoListAsset.Assets.primaryText.color
    }
    
    func displayList(items: [TaskCollectionViewCellConfiguration]) {
        cellsConfigurations = items
        updateTasksCount(items.count)
        let sectionToApply = 0
        var snapshot = NSDiffableDataSourceSnapshot<SectionIdentifireType, ItemIdentifireType>()
        snapshot.appendSections([sectionToApply])
        snapshot.appendItems(items.map(\.id), toSection: sectionToApply)
        dataSource.apply(snapshot)
    }
    
    func updateCompletionStateForItem(
        with id: String,
        for items: [TaskCollectionViewCellConfiguration]
    ) {
        cellsConfigurations = items
        updateTasksCount(items.count)
        var snapshot = dataSource.snapshot()
        snapshot.reconfigureItems([id])
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    func presentShareSheet(text: String) {
        let activityViewController = UIActivityViewController(
            activityItems: [text],
            applicationActivities: nil
        )
        present(activityViewController, animated: true)
    }
}

extension HomeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        output?.searchTextDidChange(searchController.searchBar.text ?? "")
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        output?.searchTextDidChange("")
    }
}

extension HomeViewController {
    func collectionView(
        _ collectionView: UICollectionView,
        contextMenuConfigurationForItemAt indexPath: IndexPath,
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        guard indexPath.item < cellsConfigurations.count else {
            return nil
        }

        let item = cellsConfigurations[indexPath.item]

        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [weak self] _ in
            guard let self else {
                return nil
            }

            let editAction = UIAction(
                title: "Редактировать",
                image: UIImage(systemName: "square.and.pencil")
            ) { [weak self] _ in
                self?.output?.didTapEdit(taskID: item.id)
            }

            let shareAction = UIAction(
                title: "Поделиться",
                image: UIImage(systemName: "square.and.arrow.up")
            ) { [weak self] _ in
                self?.output?.didTapShare(taskID: item.id)
            }

            let deleteAction = UIAction(
                title: "Удалить",
                image: UIImage(systemName: "trash"),
                attributes: .destructive
            ) { [weak self] _ in
                self?.output?.didTapDelete(taskID: item.id)
            }

            return UIMenu(title: "", children: [editAction, shareAction, deleteAction])
        }
    }

    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        false
    }

    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        false
    }
}
