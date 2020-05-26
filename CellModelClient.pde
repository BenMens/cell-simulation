interface CellModelClient {
    void onAddCodon(CodonBaseModel codonModel);

    void onDestroy(CellModel cellModel);

    void onRemoveCodon(CodonBaseModel codonModel);
}