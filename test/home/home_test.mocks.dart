// Mocks generated by Mockito 5.3.2 from annotations
// in stow/test/home/home_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i6;

import 'package:cloud_firestore/cloud_firestore.dart' as _i2;
import 'package:firebase_storage/firebase_storage.dart' as _i3;
import 'package:mockito/mockito.dart' as _i1;
import 'package:stow/models/container.dart' as _i7;
import 'package:stow/models/food_item.dart' as _i9;
import 'package:stow/models/grocery_lists.dart' as _i10;
import 'package:stow/models/recipe.dart' as _i8;
import 'package:stow/models/user.dart' as _i4;
import 'package:stow/utils/firebase.dart' as _i5;
import 'package:stow/utils/firebase_storage.dart' as _i11;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeCollectionReference_0<T extends Object?> extends _i1.SmartFake
    implements _i2.CollectionReference<T> {
  _FakeCollectionReference_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeFirebaseStorage_1 extends _i1.SmartFake
    implements _i3.FirebaseStorage {
  _FakeFirebaseStorage_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [StowUser].
///
/// See the documentation for Mockito's code generation for more information.
class MockStowUser extends _i1.Mock implements _i4.StowUser {
  MockStowUser() {
    _i1.throwOnMissingStub(this);
  }

  @override
  String get uid => (super.noSuchMethod(
        Invocation.getter(#uid),
        returnValue: '',
      ) as String);
  @override
  set uid(String? _uid) => super.noSuchMethod(
        Invocation.setter(
          #uid,
          _uid,
        ),
        returnValueForMissingStub: null,
      );
  @override
  set email(String? _email) => super.noSuchMethod(
        Invocation.setter(
          #email,
          _email,
        ),
        returnValueForMissingStub: null,
      );
}

/// A class which mocks [FirebaseService].
///
/// See the documentation for Mockito's code generation for more information.
class MockFirebaseService extends _i1.Mock implements _i5.FirebaseService {
  MockFirebaseService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  int get numWrites => (super.noSuchMethod(
        Invocation.getter(#numWrites),
        returnValue: 0,
      ) as int);
  @override
  set numWrites(int? _numWrites) => super.noSuchMethod(
        Invocation.setter(
          #numWrites,
          _numWrites,
        ),
        returnValueForMissingStub: null,
      );
  @override
  int get numReads => (super.noSuchMethod(
        Invocation.getter(#numReads),
        returnValue: 0,
      ) as int);
  @override
  set numReads(int? _numReads) => super.noSuchMethod(
        Invocation.setter(
          #numReads,
          _numReads,
        ),
        returnValueForMissingStub: null,
      );
  @override
  String get uid => (super.noSuchMethod(
        Invocation.getter(#uid),
        returnValue: '',
      ) as String);
  @override
  _i2.CollectionReference<Object?> get containerCollection =>
      (super.noSuchMethod(
        Invocation.getter(#containerCollection),
        returnValue: _FakeCollectionReference_0<Object?>(
          this,
          Invocation.getter(#containerCollection),
        ),
      ) as _i2.CollectionReference<Object?>);
  @override
  _i2.CollectionReference<Object?> get userCollection => (super.noSuchMethod(
        Invocation.getter(#userCollection),
        returnValue: _FakeCollectionReference_0<Object?>(
          this,
          Invocation.getter(#userCollection),
        ),
      ) as _i2.CollectionReference<Object?>);
  @override
  _i2.CollectionReference<Object?> get foodItemCollection =>
      (super.noSuchMethod(
        Invocation.getter(#foodItemCollection),
        returnValue: _FakeCollectionReference_0<Object?>(
          this,
          Invocation.getter(#foodItemCollection),
        ),
      ) as _i2.CollectionReference<Object?>);
  @override
  _i2.CollectionReference<Object?> get recipeCollection => (super.noSuchMethod(
        Invocation.getter(#recipeCollection),
        returnValue: _FakeCollectionReference_0<Object?>(
          this,
          Invocation.getter(#recipeCollection),
        ),
      ) as _i2.CollectionReference<Object?>);
  @override
  _i2.CollectionReference<Object?> get groceryListCollection =>
      (super.noSuchMethod(
        Invocation.getter(#groceryListCollection),
        returnValue: _FakeCollectionReference_0<Object?>(
          this,
          Invocation.getter(#groceryListCollection),
        ),
      ) as _i2.CollectionReference<Object?>);
  @override
  _i6.Future<_i6.Stream<List<_i7.Container>>> get containers =>
      (super.noSuchMethod(
        Invocation.getter(#containers),
        returnValue: _i6.Future<_i6.Stream<List<_i7.Container>>>.value(
            _i6.Stream<List<_i7.Container>>.empty()),
      ) as _i6.Future<_i6.Stream<List<_i7.Container>>>);
  @override
  _i6.Future<dynamic> updateUserData(
    String? email,
    String? firstName,
    String? lastName,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateUserData,
          [
            email,
            firstName,
            lastName,
          ],
        ),
        returnValue: _i6.Future<dynamic>.value(),
      ) as _i6.Future<dynamic>);
  @override
  _i6.Future<dynamic> updateUserDataNoContainers(
    String? email,
    String? firstName,
    String? lastName,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateUserDataNoContainers,
          [
            email,
            firstName,
            lastName,
          ],
        ),
        returnValue: _i6.Future<dynamic>.value(),
      ) as _i6.Future<dynamic>);
  @override
  _i6.Future<List<String>> getFirstAndLastName() => (super.noSuchMethod(
        Invocation.method(
          #getFirstAndLastName,
          [],
        ),
        returnValue: _i6.Future<List<String>>.value(<String>[]),
      ) as _i6.Future<List<String>>);
  @override
  _i6.Future<dynamic> updateContainers(String? mac) => (super.noSuchMethod(
        Invocation.method(
          #updateContainers,
          [mac],
        ),
        returnValue: _i6.Future<dynamic>.value(),
      ) as _i6.Future<dynamic>);
  @override
  _i6.Future<dynamic> updateContainerData(
    String? name,
    String? size,
    String? mac,
    int? value,
    bool? full,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateContainerData,
          [
            name,
            size,
            mac,
            value,
            full,
          ],
        ),
        returnValue: _i6.Future<dynamic>.value(),
      ) as _i6.Future<dynamic>);
  @override
  _i6.Future<dynamic> updateContainerNameAndSize(
    String? name,
    String? size,
    String? mac,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateContainerNameAndSize,
          [
            name,
            size,
            mac,
          ],
        ),
        returnValue: _i6.Future<dynamic>.value(),
      ) as _i6.Future<dynamic>);
  @override
  _i6.Future<dynamic> updateContainerName(
    String? mac,
    String? name,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateContainerName,
          [
            mac,
            name,
          ],
        ),
        returnValue: _i6.Future<dynamic>.value(),
      ) as _i6.Future<dynamic>);
  @override
  _i6.Future<dynamic> deleteContainer(String? mac) => (super.noSuchMethod(
        Invocation.method(
          #deleteContainer,
          [mac],
        ),
        returnValue: _i6.Future<dynamic>.value(),
      ) as _i6.Future<dynamic>);
  @override
  _i6.Future<dynamic> deleteRecipe(String? recipeId) => (super.noSuchMethod(
        Invocation.method(
          #deleteRecipe,
          [recipeId],
        ),
        returnValue: _i6.Future<dynamic>.value(),
      ) as _i6.Future<dynamic>);
  @override
  _i6.Future<dynamic> updateRecipeData(
    String? recipeId,
    String? name,
    List<String>? instructions,
    String? userId,
    List<String>? ingredients,
    int? cookTimeMin,
    int? prepTimeMin,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateRecipeData,
          [
            recipeId,
            name,
            instructions,
            userId,
            ingredients,
            cookTimeMin,
            prepTimeMin,
          ],
        ),
        returnValue: _i6.Future<dynamic>.value(),
      ) as _i6.Future<dynamic>);
  @override
  _i6.Future<dynamic> updateRecipes(String? argId) => (super.noSuchMethod(
        Invocation.method(
          #updateRecipes,
          [argId],
        ),
        returnValue: _i6.Future<dynamic>.value(),
      ) as _i6.Future<dynamic>);
  @override
  _i6.Future<List<String>> getAddresses() => (super.noSuchMethod(
        Invocation.method(
          #getAddresses,
          [],
        ),
        returnValue: _i6.Future<List<String>>.value(<String>[]),
      ) as _i6.Future<List<String>>);
  @override
  _i6.Future<List<String>> getRecipeAddresses() => (super.noSuchMethod(
        Invocation.method(
          #getRecipeAddresses,
          [],
        ),
        returnValue: _i6.Future<List<String>>.value(<String>[]),
      ) as _i6.Future<List<String>>);
  @override
  _i6.Future<List<String>> getFoodAddresses() => (super.noSuchMethod(
        Invocation.method(
          #getFoodAddresses,
          [],
        ),
        returnValue: _i6.Future<List<String>>.value(<String>[]),
      ) as _i6.Future<List<String>>);
  @override
  _i6.Future<bool> getFull(String? address) => (super.noSuchMethod(
        Invocation.method(
          #getFull,
          [address],
        ),
        returnValue: _i6.Future<bool>.value(false),
      ) as _i6.Future<bool>);
  @override
  _i6.Future<int> getVal(String? address) => (super.noSuchMethod(
        Invocation.method(
          #getVal,
          [address],
        ),
        returnValue: _i6.Future<int>.value(0),
      ) as _i6.Future<int>);
  @override
  _i6.Future<String> getSize(String? address) => (super.noSuchMethod(
        Invocation.method(
          #getSize,
          [address],
        ),
        returnValue: _i6.Future<String>.value(''),
      ) as _i6.Future<String>);
  @override
  _i6.Future<List<_i7.Container>?> getContainerList() => (super.noSuchMethod(
        Invocation.method(
          #getContainerList,
          [],
        ),
        returnValue: _i6.Future<List<_i7.Container>?>.value(),
      ) as _i6.Future<List<_i7.Container>?>);
  @override
  _i6.Future<List<_i8.Recipe>?> getRecipeList() => (super.noSuchMethod(
        Invocation.method(
          #getRecipeList,
          [],
        ),
        returnValue: _i6.Future<List<_i8.Recipe>?>.value(),
      ) as _i6.Future<List<_i8.Recipe>?>);
  @override
  _i6.Future<List<_i9.FoodItem>?> getFoodItemList() => (super.noSuchMethod(
        Invocation.method(
          #getFoodItemList,
          [],
        ),
        returnValue: _i6.Future<List<_i9.FoodItem>?>.value(),
      ) as _i6.Future<List<_i9.FoodItem>?>);
  @override
  _i6.Future<dynamic> updateFoodItemData(
    String? name,
    DateTime? expDate,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateFoodItemData,
          [
            name,
            expDate,
          ],
        ),
        returnValue: _i6.Future<dynamic>.value(),
      ) as _i6.Future<dynamic>);
  @override
  _i6.Future<dynamic> updateExistingFoodItem(_i9.FoodItem? foodItem) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateExistingFoodItem,
          [foodItem],
        ),
        returnValue: _i6.Future<dynamic>.value(),
      ) as _i6.Future<dynamic>);
  @override
  _i6.Future<dynamic> updateFoodItems(dynamic mac) => (super.noSuchMethod(
        Invocation.method(
          #updateFoodItems,
          [mac],
        ),
        returnValue: _i6.Future<dynamic>.value(),
      ) as _i6.Future<dynamic>);
  @override
  _i6.Future<dynamic> deleteFoodItems(String? mac) => (super.noSuchMethod(
        Invocation.method(
          #deleteFoodItems,
          [mac],
        ),
        returnValue: _i6.Future<dynamic>.value(),
      ) as _i6.Future<dynamic>);
  @override
  _i6.Future<List<_i10.GroceryList>?> getGroceryLists() => (super.noSuchMethod(
        Invocation.method(
          #getGroceryLists,
          [],
        ),
        returnValue: _i6.Future<List<_i10.GroceryList>?>.value(),
      ) as _i6.Future<List<_i10.GroceryList>?>);
  @override
  _i6.Future<dynamic> createGroceryList(_i10.GroceryList? groceryList) =>
      (super.noSuchMethod(
        Invocation.method(
          #createGroceryList,
          [groceryList],
        ),
        returnValue: _i6.Future<dynamic>.value(),
      ) as _i6.Future<dynamic>);
  @override
  _i6.Future<dynamic> deleteGroceryList(String? id) => (super.noSuchMethod(
        Invocation.method(
          #deleteGroceryList,
          [id],
        ),
        returnValue: _i6.Future<dynamic>.value(),
      ) as _i6.Future<dynamic>);
  @override
  _i6.Future<dynamic> updateGroceryList(
    String? id,
    _i10.GroceryList? newGroceryList,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateGroceryList,
          [
            id,
            newGroceryList,
          ],
        ),
        returnValue: _i6.Future<dynamic>.value(),
      ) as _i6.Future<dynamic>);
  @override
  _i6.Future<bool> checkLowContainerGroceryList() => (super.noSuchMethod(
        Invocation.method(
          #checkLowContainerGroceryList,
          [],
        ),
        returnValue: _i6.Future<bool>.value(false),
      ) as _i6.Future<bool>);
}

/// A class which mocks [Storage].
///
/// See the documentation for Mockito's code generation for more information.
class MockStorage extends _i1.Mock implements _i11.Storage {
  MockStorage() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.FirebaseStorage get storage => (super.noSuchMethod(
        Invocation.getter(#storage),
        returnValue: _FakeFirebaseStorage_1(
          this,
          Invocation.getter(#storage),
        ),
      ) as _i3.FirebaseStorage);
  @override
  _i6.Future<void> uploadFile(
    String? filePath,
    String? fileName,
    String? folder,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #uploadFile,
          [
            filePath,
            fileName,
            folder,
          ],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);
  @override
  _i6.Future<String>? getFoodItemImage(String? name) =>
      (super.noSuchMethod(Invocation.method(
        #getFoodItemImage,
        [name],
      )) as _i6.Future<String>?);
}
