class CodonController implements CodonModelClient, CodonViewClient {
    CodonBaseModel codonModel;
    CodonView codonView;


    CodonController(ViewBase parentView, CodonBaseModel codonModel) {
        this.codonModel = codonModel;
        this.codonView = new CodonView(parentView, codonModel);

        this.codonModel.registerClient(this);
        this.codonView.registerClient(this);
    }
}
