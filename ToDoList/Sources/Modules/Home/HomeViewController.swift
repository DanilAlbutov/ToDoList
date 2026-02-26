import Foundation
import UIKit
import SnapKit

final class HomeViewController: UIViewController, UICollectionViewDelegate {
    var output: HomeViewOutput?
    
    typealias ItemIdentifireType = String
    typealias SectionIdentifireType = Int
    
    private var items: [TaskCollectionViewCellConfiguration] = []
    private lazy var searchController: UISearchController = {
        $0.obscuresBackgroundDuringPresentation = false
        $0.searchBar.placeholder = "Search"
        $0.searchBar.searchBarStyle = .minimal
        $0.searchResultsUpdater = self
        $0.searchBar.delegate = self
        $0.searchBar.tintColor = ToDoListAsset.Assets.primaryText.color
        $0.searchBar.searchTextField.textColor = ToDoListAsset.Assets.primaryText.color
        return $0
    }(UISearchController(searchResultsController: nil))
    
    private let loader = UIActivityIndicatorView(style: .large)
    private let bottomBarView = HomeBottomBarView()
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: .createSingleListLayout())
    private lazy var dataSource = UICollectionViewDiffableDataSource<
        SectionIdentifireType, 
        ItemIdentifireType
    >(collectionView: collectionView) { [weak self] collectionView, indexPath, _ in
        self?.cell(forItemAt: indexPath)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBottomBar()
        setupCollectionView()
        output?.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        output?.viewWillAppear()
    }
    
    private func cell(forItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TaskCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? TaskCollectionViewCell else {
            assertionFailure()
            return UICollectionViewCell()
        }
        let configuration = items[indexPath.item]
        cell.configure(with: configuration)
        cell.onCheckButtonTapped = { [weak self] in
            self?.output?.checkButtonTapped(taskID: configuration.id)
        }
        return cell
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

        view.addSubview(loader)
        loader.hidesWhenStopped = true
        loader.color = ToDoListAsset.Assets.primaryText.color
        loader.snp.makeConstraints {
            $0.center.equalTo(collectionView.snp.center)
        }
    }

    private func setupBottomBar() {
        view.addSubview(bottomBarView)
        bottomBarView.onComposeTapped = { [weak self] in
            self?.output?.didTapCreateTask()
        }

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
        title = "Задачи"        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true        
        setupLargeTitle()       
    }
    
    func displayList(items: [TaskCollectionViewCellConfiguration]) {
        hideLoading()
        self.items = items
        updateTasksCount(items.count)
        let sectionToApply = 0
        var snapshot = NSDiffableDataSourceSnapshot<SectionIdentifireType, ItemIdentifireType>()
        snapshot.appendSections([sectionToApply])
        snapshot.appendItems(items.map(\.id), toSection: sectionToApply)
        dataSource.apply(snapshot)
    }

    func showLoading() {        
        loader.startAnimating()
    }

    func hideLoading() {
        loader.stopAnimating()
    }

    func updateItem(
        with id: String,
        for items: [TaskCollectionViewCellConfiguration]?
    ) {
        if let itemsToUpdate = items {
            self.items = itemsToUpdate
            updateTasksCount(itemsToUpdate.count)
        }
        
        var snapshot = dataSource.snapshot()
        snapshot.reconfigureItems([id])
        dataSource.apply(snapshot, animatingDifferences: true)
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
        guard indexPath.item < items.count else {
            return nil
        }

        let item = items[indexPath.item]
        return HomeContextMenuBuilder.makeContextMenuAction(
            identifier: indexPath as NSCopying,
            previewProvider: {
                HomeTaskPreviewPopoverView(configuration: item.infoConfig)
            }
        ) { [weak self] _ in
            self?.output?.didTapEdit(taskID: item.id)
        } onShare: { [weak self] _ in
            self?.output?.didTapShare(taskID: item.id)
        } onDelete: { [weak self] _ in
            self?.output?.didTapDelete(taskID: item.id)
        }
    }
}

fileprivate extension UIViewController {
    func setupLargeTitle() {
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
        navigationItem.largeTitleDisplayMode = .always
    }
}
