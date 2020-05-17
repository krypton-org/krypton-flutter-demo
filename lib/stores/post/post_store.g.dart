// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$PostStore on _PostStore, Store {
  Computed<bool> _$loadingComputed;

  @override
  bool get loading =>
      (_$loadingComputed ??= Computed<bool>(() => super.loading)).value;

  final _$fetchPostsFutureAtom = Atom(name: '_PostStore.fetchPostsFuture');

  @override
  ObservableFuture<PostList> get fetchPostsFuture {
    _$fetchPostsFutureAtom.context.enforceReadPolicy(_$fetchPostsFutureAtom);
    _$fetchPostsFutureAtom.reportObserved();
    return super.fetchPostsFuture;
  }

  @override
  set fetchPostsFuture(ObservableFuture<PostList> value) {
    _$fetchPostsFutureAtom.context.conditionallyRunInAction(() {
      super.fetchPostsFuture = value;
      _$fetchPostsFutureAtom.reportChanged();
    }, _$fetchPostsFutureAtom, name: '${_$fetchPostsFutureAtom.name}_set');
  }

  final _$postListAtom = Atom(name: '_PostStore.postList');

  @override
  PostList get postList {
    _$postListAtom.context.enforceReadPolicy(_$postListAtom);
    _$postListAtom.reportObserved();
    return super.postList;
  }

  @override
  set postList(PostList value) {
    _$postListAtom.context.conditionallyRunInAction(() {
      super.postList = value;
      _$postListAtom.reportChanged();
    }, _$postListAtom, name: '${_$postListAtom.name}_set');
  }

  final _$successAtom = Atom(name: '_PostStore.success');

  @override
  bool get success {
    _$successAtom.context.enforceReadPolicy(_$successAtom);
    _$successAtom.reportObserved();
    return super.success;
  }

  @override
  set success(bool value) {
    _$successAtom.context.conditionallyRunInAction(() {
      super.success = value;
      _$successAtom.reportChanged();
    }, _$successAtom, name: '${_$successAtom.name}_set');
  }

  final _$getPostsAsyncAction = AsyncAction('getPosts');

  @override
  Future<dynamic> getPosts() {
    return _$getPostsAsyncAction.run(() => super.getPosts());
  }
}
