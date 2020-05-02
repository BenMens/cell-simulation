class DefaultViewFactory implements ViewFactory {
    CellView createView(CellModel cellModel) {
        return new cell_simulation.CellView(cellModel);
    }

    BodyView createView(BodyModel bodyModel) {
        return new cell_simulation.BodyView(bodyModel);
    }
}
