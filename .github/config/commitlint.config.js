// Copyright (c) Qualcomm Technologies, Inc. and/or its subsidiaries.
// SPDX-License-Identifier: BSD-3-Clause
module.exports = {
  extends: ['@commitlint/config-conventional'],
  ignores: [(message) => message.startsWith('Merge ')],
  rules: {
    "body-case": [2,"always", "sentence-case"],
    "body-leading-blank": [2, "always"],
    "type-enum": [2, "always",
        [
            "build",
            "chore",
            "ci",
            "docs",
            "feat",
            "fix",
            "perf",
            "refactor",
            "revert",
            "style",
            "test",
            "release",
        ]
    ],
  }
};