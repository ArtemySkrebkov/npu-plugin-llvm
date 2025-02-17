//===- QuantOpsBase.td - Quantization dialect base ---------*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// Predicates for types in the Quantization dialect.
//
//===----------------------------------------------------------------------===//

#ifndef DIALECT_QUANT_QUANT_OPS_BASE_
#define DIALECT_QUANT_QUANT_OPS_BASE_

include "mlir/IR/OpBase.td"

def Quantization_Dialect : Dialect {
  let name = "quant";
  let cppNamespace = "::mlir::quant";

  let useDefaultTypePrinterParser = 1;
}

//===----------------------------------------------------------------------===//
// Quantization type definitions
//===----------------------------------------------------------------------===//

class quant_TypedPrimitiveOrContainer<Type etype> :
    Type<Or<[etype.predicate,
                TensorOf<[etype]>.predicate,
                VectorOf<[etype]>.predicate]>,
         "primitive/tensor/vector of " # etype.summary>;

// An implementation of QuantizedType.
def quant_QuantizedType :
    Type<CPred<"::llvm::isa<mlir::quant::QuantizedType>($_self)">, "QuantizedType">;

// A primitive type that can represent a real value. This is either a
// floating point value or a quantized type.
def quant_RealPrimitiveType :
    Type<Or<[AnyFloat.predicate, quant_QuantizedType.predicate]>,
    "real valued primitive (float or quantized type)">;

// A primitive type that can represent a storage value. This is either an
// integer or quantized type.
def quant_StoragePrimitiveType :
    Type<Or<[AnySignlessInteger.predicate, quant_QuantizedType.predicate]>,
    "quantized storage primitive (integer or quantized type)">;

// A primitive or container of RealPrimitiveType.
def quant_RealValueType :
    quant_TypedPrimitiveOrContainer<quant_RealPrimitiveType>;

// A primitive or container of StoragePrimitiveType.
def quant_StorageValueType :
    quant_TypedPrimitiveOrContainer<quant_StoragePrimitiveType>;

// Either a real valued or storage primitive or container type.
def quant_RealOrStorageValueType :
    Type<Or<[quant_RealValueType.predicate, quant_StorageValueType.predicate]>,
    "real valued or storage primitive or container type">;

// An implementation of UniformQuantizedType.
def quant_UniformQuantizedType :
    DialectType<Quantization_Dialect,
                CPred<"::llvm::isa<UniformQuantizedType>($_self)">,
                "UniformQuantizedType">;

// An implementation of QuantileQuantizedType.
def quant_QuantileQuantizedType :
    DialectType<Quantization_Dialect,
                CPred<"::llvm::isa<QuantileQuantizedType>($_self)">,
                "QuantileQuantizedType">;

// Predicate for detecting a container or primitive of UniformQuantizedType.
def quant_UniformQuantizedValueType :
    quant_TypedPrimitiveOrContainer<quant_UniformQuantizedType>;

// Predicate for detecting a container or primitive of QuantileQuantizedType.
def quant_QuantileQuantizedValueType :
    quant_TypedPrimitiveOrContainer<quant_QuantileQuantizedType>;

#endif // DIALECT_QUANT_QUANT_OPS_BASE_
