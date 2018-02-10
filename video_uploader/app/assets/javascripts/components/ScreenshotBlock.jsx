var ScreenshotBlock = createReactClass({
  getInitialState: function() {
    return {currentIndex: 0, maxIndex: 100, imgExtension: 'png'};
  },

  componentDidMount: function() {
    this.fetchScreenshotInfo(function(data) {
      console.log("First call...");
      that.setState({
        currentIndex: Number(data.last)
      });
      $('img[usemap]').rwdImageMaps();
    });

    var that = this;
    this.timerID = setInterval(
      function(){ that.fetchScreenshotInfo() },
      5000
    );
  },

  componentWillMount: function () {
    document.addEventListener("keydown", this.handleKeyUp, false);
  },

  componentWillUnmount: function() {
    clearInterval(this.timerID);
    document.removeEventListener("keydown", this.handleKeyUp, false);
  },

  handleKeyUp: function(e) {
    if (e.keyCode == 37) {
      e.preventDefault();
      this.prevImage();
    }
    if (e.keyCode == 39) {
      e.preventDefault();
      this.nextImage();
    }
  },

  fetchScreenshotInfo: function(callback) {
    var that = this;
    $.getJSON(this.props.baseUrl, function(data){
      console.log(data);
      that.setState({
        maxIndex: Number(data.last),
        imgExtension: data.extension
      });
      if (callback) {
        callback(data);
      }
    })
  },

  lpad: function(n, width=3, z=0) {
    return (String(z).repeat(width) + String(n)).slice(String(n).length)
  },

  currentImage: function() {
    var imgBlock = "";
    if (this.state.currentIndex > 0) {
      imgBlock = <img className="screen-snapshot responsive-img" useMap="#navmap" src={this.imgUrl(this.state.currentIndex)} />;
    }
    return imgBlock;
  },

  nextImage: function() {
    var newIndex = this.state.currentIndex;
    if (this.state.currentIndex < this.state.maxIndex) {
      newIndex++;
    }

    this.setState({currentIndex: newIndex});
  },

  prevImage: function() {
    var newIndex = this.state.currentIndex;
    if (this.state.currentIndex > 2) {
      newIndex--;
    }
    this.setState({currentIndex: newIndex});
  },

  imgUrl: function(imageId) {
    return this.props.baseUrl + "snapshot" + this.lpad(imageId, 5) + "." + this.state.imgExtension;
  },

  downloadCurrentImg: function () {
    window.open(this.currentImgUrl(), '_blank');
  },

  currentImgUrl: function () {
    return this.imgUrl(this.state.currentIndex);
  },

  goLatest: function() {
    var newIndex = this.state.maxIndex;
    this.setState({currentIndex: newIndex});
  },

  render: function() {
    return <div className="screenshots">
      <div className="row">
        <div className="current-screen col s12">
          <map name="navmap">
            <area href="javascript:;" shape="rect" coords="0,0,960,1080" alt="Previous Screenshot" title="Previous Screenshot" onClick={this.prevImage} />
            <area href="javascript:;" shape="rect" coords="960,0,1920,1080" alt="Next Screenshot" title="Previous Screenshot" onClick={this.nextImage} />
          </map>
          {this.currentImage()}
        </div>
      </div>

      <div className="row">
        <div className="screen-navs center-align col s12">
          <button className="btn-large" onClick={this.prevImage}>
            <i className="material-icons large">navigate_before</i>
          </button>
          &nbsp;
          <button className="btn-large" onClick={this.goLatest}>Latest</button>
          &nbsp;
          <button className="btn-large" onClick={this.nextImage}>
            <i className="material-icons large">navigate_next</i>
          </button>
        </div>
      </div>

      <div className="row">
        <div className="screen-options center-align col s12">
          <a className="btn light-green" onClick={this.downloadCurrentImg} target="_blank">
            <i className="material-icons left">file_download</i>
            Download screenshot
          </a>
        </div>
      </div>
    </div>;
  }
});
