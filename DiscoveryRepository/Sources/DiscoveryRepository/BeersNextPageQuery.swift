
public struct BeersNextPageQuery: Equatable {
    var pageIndex: Int

    init(pageIndex: Int) {
        self.pageIndex = pageIndex
    }

    public static var initial: BeersNextPageQuery {
        BeersNextPageQuery(pageIndex: 1)
    }

    /// Generates the `next page query` based on the `amount of items returned by the last page`.
    ///
    /// _Note_: Since `PunkAPI` is simple and `doesn't provide` ways to know about `next page or total items count`,
    ///  a `nil next page query` is generated `when last page returned no items`.
    ///
    func buildNextPage(withLastPageItemsCount itemsCount: Int) -> BeersNextPageQuery? {
        guard itemsCount > 0 else { return nil }

        return BeersNextPageQuery(pageIndex: self.pageIndex + 1)
    }
}
