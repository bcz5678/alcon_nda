import 'dart:async';
import 'dart:math';
import 'dart:nativewrappers/_internal/vm/lib/typed_data_patch.dart';

/*
class _PdfStream extends Stream<List<int>> {
  _PdfStream(
      this._pdfData,
      int? position,
      this._end
      ) : _position = position ?? 0;

  // Stream controller.
  late StreamController<Uint8List> _controller;

  // Read the list in blocks of size 64k.
  static const int _blockSize = 64 * 1024;

  // Information about the underlying file.
  List<int>? _pdfData;
  int _position;
  int? _end;
  final Completer _closeCompleter = new Completer();

  // Has the stream been paused or unsubscribed?
  bool _unsubscribed = false;

  // Is there a read currently in progress?
  bool _readInProgress = true;
  bool _closed = false;
  bool _atEnd = false;


  /*
  _PdfStream.forStdin() : _position = 0;

  _PdfStream.forRandomAccessFile(RandomAccessFile f)
      : _position = 0,
        _openedFile = f;

   */

  //Stream Subscription of Uint8List to subscribe to
  StreamSubscription<Uint8List> listen(
      void onData(Uint8List event)?, {
        Function? onError,
        void onDone()?,
        bool? cancelOnError,
      }) {
    _controller = new StreamController<Uint8List>(
      sync: true,
      onListen: _start,
      onResume: _readBlock,
      onCancel: () {
        _unsubscribed = true;
        //return _closeFile();
      },
    );
    return _controller.stream.listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }



  Future _closePdfRead() {
    if (_readInProgress || _closed) {
      return _closeCompleter.future;
    }
    _closed = true;

    void done() {
      _closeCompleter.complete();
      _controller.close();
    }

    //_openedFile!.close().catchError(_controller.addError).whenComplete(done);
    return _closeCompleter.future;
  }



  void _readBlock() {
    // Don't start a new read if one is already in progress.
    if (_readInProgress) return;
    if (_atEnd) {
     //_closeFile();
      return;
    }
    _readInProgress = true;
    int readBytes = _blockSize;
    final end = _end;
    if (end != null) {
      readBytes = min(readBytes, end - _position);
      if (readBytes < 0) {
        _readInProgress = false;
        if (!_unsubscribed) {
          _controller.addError(new RangeError("Bad end position: $end"));
          _closePdfRead();
          _unsubscribed = true;
        }
        return;
      }
    }
    _pdfData!
        .read(readBytes)
        .then((block) {
      _readInProgress = false;
      if (_unsubscribed) {
        _closeFile();
        return;
      }
      _position += block.length;
      // read() may return less than `readBytes` if `_openFile` is a pipe or
      // terminal or if a signal is received. Only a empty return indicates
      // that the write side of the pipe is closed or that we are at the end
      // of a file.
      // See https://man7.org/linux/man-pages/man2/read.2.html
      if (block.length == 0 || (_end != null && _position == _end)) {
        _atEnd = true;
      }
      if (!_atEnd && !_controller.isPaused) {
        _readBlock();
      }
      if (block.length > 0) {
        _controller.add(block);
      }
      if (_atEnd) {
        _closePdfRead();
      }
    })
        .catchError((e, s) {
      if (!_unsubscribed) {
        _controller.addError(e, s);
        _closePdfRead();
        _unsubscribed = true;
      }
    });
  }



  void _start() {
    if (_position < 0) {
      _controller.addError(new RangeError("Bad start position: $_position"));
      _controller.close();
      _closeCompleter.complete();
      return;
    }

    void onReady(List<int> pdfData) {
      _pdfData = pdfData;
      _readInProgress = false;
      _readBlock();
    }

    void onOpenPdfData(List<int> pdfData) {
      if (_position > 0) {
        pdfData
            .setPosition(_position)
            .then(
          onReady,
          onError: (e, s) {
            _controller.addError(e, s);
            _readInProgress = false;
            _closePdfRead();
          },
        );
      } else {
        onReady(pdfData);
      }
    }

    void openFailed(error, stackTrace) {
      _controller.addError(error, stackTrace);
      _controller.close();
      _closeCompleter.complete();
    }

    //final path = _path;
    final pdfData = _pdfData;
    if (pdfData != null) {
      onOpenPdfData(pdfData);
    } else if (path != null) {
      new File(
        path,
      ).open(mode: FileMode.read).then(onOpenFile, onError: openFailed);
    } else {
      try {
        onOpenFile(_File._openStdioSync(0));
      } catch (e, s) {
        openFailed(e, s);
      }
    }
  }
}

 */